%% THROTTLE_PARAMS  Driver input chain: twist grip -> motor current request
%
%  This is the block that sits between the driver and the current controller.
%  Without it the model cannot reproduce a real run from 06_data/, because
%  what the VESC actually receives is a RATE-LIMITED current request, never a
%  step.
%
%  Source: 03_hardware/vesc/MOTOR_1.9_app.xml
%  Code  : 03_hardware/vesc/_firmware/applications/app_adc.c

%% ------------------------------------------------------------------
%% 1. Which application is running
%% ------------------------------------------------------------------
% app_to_use = 2 = APP_ADC        -> analog twist grip on the ADC pin
% app_adc_conf.ctrl_type = 3      -> ADC_CTRL_TYPE_CURRENT_REV_BUTTON
%
% So the vehicle is in CURRENT (torque) control, reverse selected by a button.
% There is no speed loop and no duty loop in the driver path. Everything the
% PPM / nunchuk / PAS entries in the XML describe is inactive - ignore them.
thr.mode         = 'CURRENT';      % CONFIG

%% ------------------------------------------------------------------
%% 2. Sensor mapping (raw ADC volts -> normalised demand)
%% ------------------------------------------------------------------
thr.v_start      = 0.81;           % [V] CONFIG  demand = 0 below this
thr.v_end        = 3.30;           % [V] CONFIG  demand = 1 at and above this
thr.v_min        = 0.00;           % [V] CONFIG  fault window low
thr.v_max        = 3.60;           % [V] CONFIG  fault window high
thr.hyst         = 0.05;           % [-] CONFIG  deadband on the mapped value
thr.use_filter   = true;           % CONFIG
thr.exp_mode     = 0;              % CONFIG throttle_exp = 0 -> LINEAR map.
                                   % No expo curve to model. Good: one less
                                   % nonlinearity between demand and torque.
thr.update_rate  = 1000;           % [Hz] CONFIG  app_adc thread rate
thr.safe_start   = true;           % CONFIG  demand must return to ~0 after boot

% Normalised demand, before ramping:
thr.map_fn = @(v) min(max((v - thr.v_start)/(thr.v_end - thr.v_start), 0), 1);

%% ------------------------------------------------------------------
%% 3. Ramp limiter  <<< the part that actually shapes every launch
%% ------------------------------------------------------------------
% app_adc.c:391-398. ramp_time is the time to traverse the FULL 0..1 range,
% so the slew rate on the normalised demand is 1/ramp_time per second. The
% larger ramp_time is selected when the demand is INCREASING in magnitude.
thr.ramp_time_pos = 0.30;          % [s] CONFIG  rising
thr.ramp_time_neg = 0.10;          % [s] CONFIG  falling

% Referred to motor current with l_current_max = 120 A:
thr.di_dt_rise   = 120 / thr.ramp_time_pos;   % [A/s]  400 A/s
thr.di_dt_fall   = 120 / thr.ramp_time_neg;   % [A/s] 1200 A/s
% 0 to full throttle therefore takes 300 ms minimum at the CURRENT REQUEST,
% while the current loop itself settles in ~1.5 ms (bw 2000 rad/s). The
% driver-facing dynamics of this vehicle are set by this ramp, not by the FOC
% tuning. Any launch simulated with a current step will be wrong.

%% ------------------------------------------------------------------
%% 4. Command chain, end to end
%% ------------------------------------------------------------------
% v_adc -> map_fn -> deadband(hyst) -> rate limiter -> current_rel in [-1, 1]
%       -> mc_interface_set_current_rel: iq_ref = current_rel * l_current_max
%       -> clipped by l_in_current_max (battery), l_abs_current_max,
%          voltage fold-back and FET temperature fold-back
%
% Model it in that order. The battery-current limit is the one that bites
% first at speed: 40 A of battery at 48 V is ~1.9 kW, which at 120 A of motor
% current corresponds to only ~16 V of q-axis voltage.

thr.timeout_ms       = 1000;       % [ms] CONFIG  loss of comms -> stop
thr.timeout_brake_cur = 0;         % [A]  CONFIG  coast on timeout, no braking

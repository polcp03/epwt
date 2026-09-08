%% VEHICLE_PARAMS  Longitudinal dynamics, transmission and DC bus
%
%  Level 1 of the build order in 04_model/CLAUDE.md.
%  Same tagging rules as motor_params.m.
%
%  Sources: 03_hardware/baseline.md, 03_hardware/vesc/MOTOR_1.9.xml
%
%  READ THIS FIRST: almost nothing in this file is measured. The electrical
%  machine is well characterised; the vehicle is not. Level 1 cannot be
%  correlated against 06_data/ until the MISSING entries below are filled.

%% ------------------------------------------------------------------
%% 1. Transmission
%% ------------------------------------------------------------------
% Chain 25H, 11T motor sprocket / 92T rear sprocket. Counted teeth, so this
% is a hard number - the only genuinely MEASURED value in this file.
veh.z_motor      = 11;             % [-] MEASURED
veh.z_wheel      = 92;             % [-] MEASURED
veh.i_gear       = veh.z_wheel / veh.z_motor;   % 8.3636 [-]

% >>> LOGGING HAZARD <<<
% The VESC still has si_gear_ratio = 6.5, i.e. the OLD 72/11 = 6.55 setup.
% It does not affect the control law - only the reported speed, distance and
% tachometer. But those are exactly the channels 06_data/ will be correlated
% against, and they come out 28 % high. One field to fix on the device; until
% then, do not trust any VESC speed channel, or rescale it by 6.5/8.3636.
veh.vesc_speed_correction = 6.5 / (92/11);   % 0.7773 - apply to legacy logs

veh.eta_drive    = NaN;            % [-] chain + bearing efficiency  MISSING

%% ------------------------------------------------------------------
%% 2. Wheels and tyres
%% ------------------------------------------------------------------
% Rear (driven): 13 x 5.00-6 TR13 on a 6 in rim, pneumatic knobby.
% 13 in nominal -> 330.2 mm outer diameter, 165.1 mm unloaded radius.
veh.d_wheel_nom  = 0.3302;         % [m] MEASURED (nominal tyre size, 13 in)
veh.r_wheel_nom  = veh.d_wheel_nom / 2;        % 165.1 mm

% Loaded rolling radius. NOT the nominal radius.
% Pol's observation 2026-09-07: most of the mass sits on the rear axle and the
% tyres run at low pressure, so the rear tyre visibly squashes ("cae bastante").
% Typical deflection for a low-pressure knobby under this kind of load is
% 5-10 % of the unloaded radius. Taking ~6 %:
veh.r_roll       = 0.155;          % [m] ASSUMED, 165.1 mm - 6 %
veh.r_roll_range = [0.150 0.160];  % [m] plausible band until measured
% >>> This is the single most leveraged unmeasured number in the vehicle. <<<
% It divides torque to give tractive force AND multiplies speed, so a 6 % error
% is a 6 % error in predicted acceleration and in predicted top speed at once.
%
% HOW TO MEASURE IT (5 minutes, needs the rear wheels back on):
%   1. Rider seated on the quad, normal tyre pressure.
%   2. Mark the rear tyre and the ground at the contact patch.
%   3. Push the quad in a straight line for exactly 10 wheel revolutions.
%   4. Measure the distance travelled, D.
%   5. r_roll = D / (10 * 2*pi)
% This measures the radius the vehicle actually rolls on, deflection included.
% Rolling, not a ruler: a ruler measures the deformed shape, not the effective
% radius, and those are not the same thing.

%% ------------------------------------------------------------------
%% 3. Masses
%% ------------------------------------------------------------------
% Vehicle mass without rider. ESTIMATED, but now from two agreeing sources:
%   - 45 kg stock platform minus ~5 kg from the lead-acid -> Li-ion swap
%   - Pol lifted the quad 2026-09-07 and judged it "about 40 kg"
% Two independent estimates landing on the same number is worth more than one,
% but neither is a scale. Weigh it when convenient - see the sensitivity note
% at the bottom of this file for how much it is worth.
veh.m_vehicle    = 40;             % [kg] ESTIMATED
veh.m_driver     = 72;             % [kg] ASSUMED - Pol's mass, easy to confirm
veh.m_total      = veh.m_vehicle + veh.m_driver;   % 112 kg

veh.wheelbase    = 0.71;           % [m] ASSUMED (commercial reference)
veh.h_cg         = NaN;            % [m] CG height  MISSING - needed for load
                                   %     transfer, i.e. for any traction work
veh.x_cg         = NaN;            % [-] static rear weight fraction  MISSING

%% ------------------------------------------------------------------
%% 4. Road and aerodynamic loads
%% ------------------------------------------------------------------
veh.Crr          = NaN;            % [-]     rolling resistance  MISSING
veh.CdA          = NaN;            % [m^2]   drag area          MISSING
veh.rho_air      = 1.20;           % [kg/m^3] ASSUMED, ~20 degC sea level
veh.g            = 9.81;           % [m/s^2]
veh.slope        = 0;              % [rad]   test surface assumed flat
% Crr and CdA come out of one coastdown test together. At the speeds this quad
% reaches (< 50 km/h) rolling resistance dominates and CdA is weakly observable
% - expect a wide confidence interval on CdA and do not over-trust it.

%% ------------------------------------------------------------------
%% 5. Battery / DC bus
%% ------------------------------------------------------------------
bat.n_series     = 13;             % [-] MEASURED  13S5P
bat.n_parallel   = 5;              % [-] MEASURED
bat.cell         = 'SINC ISR18650-26A';   % Li-ion, no verified datasheet
bat.capacity_Ah  = 13;             % [Ah] ASSUMED (5 x 2.6 Ah nominal)
bat.v_nom        = 48.1;           % [V] 13 x 3.70
bat.v_max        = 54.6;           % [V] 13 x 4.20
bat.v_min        = 39.0;           % [V] 13 x 3.00, matches the VESC cut-off end
bat.R_int        = NaN;            % [Ohm] pack internal resistance  MISSING
bat.OCV_soc      = NaN;            % [V] OCV vs SoC curve            MISSING
% R_int is what turns a battery-current limit into a voltage sag, which is what
% actually clips available torque at high current. Without it the model will
% predict a stiffer bus than reality and overstate peak performance.

%% ------------------------------------------------------------------
%% 6. Derived quantities
%% ------------------------------------------------------------------
veh.v_per_wrad = veh.r_roll / veh.i_gear;      % [m/s per motor rad/s]
veh.F_per_Nm   = veh.i_gear / veh.r_roll;      % [N per Nm of motor torque]

% Vehicle inertia seen from the motor shaft, i.e. the translating mass turned
% into an equivalent rotating inertia:  J_eq = m * r_roll^2 / i_gear^2
veh.J_equiv    = veh.m_total * veh.r_roll^2 / veh.i_gear^2;   % ~0.0385 kg*m^2

%% ------------------------------------------------------------------
%% 7. WHERE THE MODEL ERROR ACTUALLY COMES FROM
%% ------------------------------------------------------------------
% Run this once mot is loaded (motor_params.m) and the priorities are obvious:
%
%   rotor inertia            1.558e-4 kg*m^2      0.4 % of the total
%   vehicle, seen from motor 3.85e-2  kg*m^2     99.6 % of the total
%
% The rotor is 250 times lighter than the vehicle it has to accelerate. So:
%   - refining J_rotor beyond its current +/-14 % changes the answer by 0.06 %
%   - a 10 % error in m_total or r_roll changes it by 10 %
%
% Sensitivity of predicted acceleration, in descending order:
%   r_roll     +/-6 %   ASSUMED   <- roll-out test, 5 min, needs wheels
%   m_total    +/-5 %   ESTIMATED <- a bathroom scale
%   Crr        unknown  MISSING   <- coastdown
%   eta_drive  unknown  MISSING   <- coastdown
%   CdA        unknown  MISSING   <- coastdown, weakly observable below 50 km/h
%   J_rotor    +/-14 %  MEASURED  <- already far better than needed
%
% Every hour spent on the motor from here buys less than a minute spent on the
% chassis. The machine is now the best-characterised part of this vehicle.

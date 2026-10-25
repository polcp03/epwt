%% BUILD_LONGITUDINAL_L1  Build level 1 of the digital twin from scratch.
%
%  Level 1 (04_model/CLAUDE.md build order): longitudinal vehicle dynamics,
%  driven by a quasi-static PMSM + VESC limits block. One state: vehicle speed.
%
%  The .slx is a build artefact. THIS script is the reviewable source: every
%  block, every connection and every parameter reference is in plain text, so
%  the model can be diffed in Git and rebuilt identically.
%
%  Built by the agent on Pol's explicit request (C01, 2026-10-08), as an
%  exception to rule 4 of 04_model/CLAUDE.md: review deadline the next morning.
%
%  Equations, one block group each:
%    VESC     iq_cmd = throttle * I_max, rate-limited by the 0.3 s / 0.1 s ramp
%    Motor    T_em = 1.5 * p * lambda_m * iq        (id = 0, MTPA and FW off)
%             iq limited by: command, voltage ceiling, battery-current limit
%             T_shaft = T_em - T_coulomb - b * w_m  (rotor drag, MEASURED C00)
%    Battery  V_bat = V_oc - R_int * I_bat
%    Vehicle  m_eq * dv/dt = min(F_trac, F_grip) - F_roll - F_aero
%             F_trac = T_shaft * i * eta / r_roll
%             F_roll = Crr * m * g ,  F_aero = 0.5 * rho * CdA * v^2
%             w_m    = v * i / r_roll
%
%  What it does NOT capture: see 04_model/results/C01_predictions.md

mdl = 'longitudinal_L1';
here = fileparts(mfilename('fullpath'));
out_dir = fullfile(here, '..', 'models');

if bdIsLoaded(mdl), close_system(mdl, 0); end
new_system(mdl);
open_system(mdl);

set_param(mdl, 'Solver', 'ode45', 'StopTime', 'scn.t_end', ...
    'MaxStep', '0.01', 'SaveOutput', 'on', 'SaveFormat', 'Dataset', ...
    'ReturnWorkspaceOutputs', 'on');

b = @(name) [mdl '/' name];

%% Driver + VESC
add_block('simulink/Sources/From Workspace', b('Throttle 0..1'), ...
    'VariableName', 'scn.throttle', 'Position', [30 95 120 125]);
add_block('simulink/Discontinuities/Rate Limiter', b('VESC ramp'), ...
    'RisingSlewLimit', '1/thr.ramp_time_pos', ...
    'FallingSlewLimit', '-1/thr.ramp_time_neg', 'Position', [160 95 210 125]);
add_block('simulink/Math Operations/Gain', b('I_motor_max'), ...
    'Gain', 'lim.i_motor_max', 'Position', [250 95 300 125]);

%% Motor + VESC limits. Quasi-static: the current loop (~1.5 ms) is far
%% faster than the vehicle (seconds), so iq is assumed to track instantly.
add_block('simulink/User-Defined Functions/MATLAB Function', ...
    b('Motor + VESC limits'), 'Position', [350 80 520 200]);
code = strjoin({
'function [T_shaft, I_bat, iq] = motor_vesc(iq_cmd, w_m, V_bat, P)'
'% Quasi-static PMSM with id = 0 and the three VESC limits on iq.'
'we = P.p * w_m;                                % electrical speed [rad/s]'
'Vmax = P.duty_max * V_bat / sqrt(3);           % SVPWM voltage ceiling'
'% 1) Voltage limit: |v_dq| = Vmax, vd = -we*Lq*iq, vq = R*iq + we*lambda'
'a  = P.Rs^2 + (we*P.Lq)^2;'
'bq = 2*P.Rs*we*P.lambda;'
'c  = (we*P.lambda)^2 - Vmax^2;'
'disc = bq^2 - 4*a*c;'
'if disc > 0'
'    iq_v = (-bq + sqrt(disc)) / (2*a);'
'else'
'    iq_v = 0;'
'end'
'% 2) Battery-current limit: 1.5*(R*iq^2 + we*lambda*iq) = V_bat*I_bat_max'
'ab = 1.5*P.Rs;  bb = 1.5*we*P.lambda;  cb = -V_bat*P.i_batt_max;'
'iq_b = (-bb + sqrt(bb^2 - 4*ab*cb)) / (2*ab);'
'% 3) Commanded current, then the smallest of the three wins'
'iq = max(min([iq_cmd, iq_v, iq_b]), 0);'
'T_em = 1.5 * P.p * P.lambda * iq;'
'T_drag = P.T_c * (w_m > 1) + P.b * w_m;        % rotor drag, MEASURED C00'
'T_shaft = T_em - T_drag;'
'I_bat = 1.5*(P.Rs*iq^2 + we*P.lambda*iq) / V_bat;   % inverter losses ignored'
}, newline);
rt = sfroot;
ch = rt.find('-isa', 'Stateflow.EMChart', 'Path', b('Motor + VESC limits'));
ch.Script = code;
pd = ch.find('-isa', 'Stateflow.Data', 'Name', 'P');
pd.Scope = 'Parameter';

%% Battery
add_block('simulink/Discrete/Memory', b('I_bat prev'), ...
    'Position', [560 260 600 290], 'Orientation', 'left');
add_block('simulink/Math Operations/Gain', b('R_int'), ...
    'Gain', 'bat.R_int', 'Position', [470 260 520 290], 'Orientation', 'left');
add_block('simulink/Sources/Constant', b('V_oc'), ...
    'Value', 'scn.V_oc', 'Position', [250 215 300 245]);
add_block('simulink/Math Operations/Sum', b('V_bat'), ...
    'Inputs', '+-', 'Position', [320 215 340 245]);

%% Vehicle
add_block('simulink/Math Operations/Gain', b('F_trac'), ...
    'Gain', 'veh.i_gear*veh.eta_drive/veh.r_roll', 'Position', [580 85 640 115]);
add_block('simulink/Sources/Constant', b('F_grip'), ...
    'Value', 'veh.mu*veh.x_cg*veh.m_total*veh.g', 'Position', [580 140 640 170]);
add_block('simulink/Math Operations/MinMax', b('Grip limit'), ...
    'Function', 'min', 'Inputs', '2', 'Position', [680 90 710 160]);
add_block('simulink/Sources/Constant', b('F_roll'), ...
    'Value', 'veh.Crr*veh.m_total*veh.g', 'Position', [680 190 740 220]);
add_block('simulink/Math Operations/Math Function', b('v squared'), ...
    'Operator', 'square', 'Position', [1000 230 1040 260], 'Orientation', 'left');
add_block('simulink/Math Operations/Gain', b('F_aero'), ...
    'Gain', '0.5*veh.rho_air*veh.CdA', 'Position', [900 230 950 260], 'Orientation', 'left');
add_block('simulink/Math Operations/Sum', b('Force balance'), ...
    'Inputs', '+--', 'Position', [780 105 810 175]);
add_block('simulink/Math Operations/Gain', b('1 over m_eq'), ...
    'Gain', '1/veh.m_eq', 'Position', [850 125 900 155]);
add_block('simulink/Continuous/Integrator', b('Integrator v'), ...
    'LimitOutput', 'on', 'LowerSaturationLimit', '0', ...
    'UpperSaturationLimit', 'inf', 'InitialCondition', 'scn.v0', ...
    'Position', [940 120 970 160]);
add_block('simulink/Math Operations/Gain', b('w_m from v'), ...
    'Gain', 'veh.i_gear/veh.r_roll', 'Position', [1000 310 1050 340], 'Orientation', 'left');

%% Outputs
outs = {'v', 'I_bat', 'T_shaft', 'F_wheel', 'iq'};
for k = 1:numel(outs)
    add_block('simulink/Sinks/Out1', b(outs{k}), 'Port', num2str(k), ...
        'Position', [1120 40+60*k 1150 54+60*k]);
end

%% Wiring
L = @(src, dst) add_line(mdl, src, dst, 'autorouting', 'smart');
L('Throttle 0..1/1', 'VESC ramp/1');
L('VESC ramp/1', 'I_motor_max/1');
L('I_motor_max/1', 'Motor + VESC limits/1');
L('w_m from v/1', 'Motor + VESC limits/2');
L('V_bat/1', 'Motor + VESC limits/3');
L('Motor + VESC limits/1', 'F_trac/1');
L('Motor + VESC limits/2', 'I_bat prev/1');
L('I_bat prev/1', 'R_int/1');
L('V_oc/1', 'V_bat/1');
L('R_int/1', 'V_bat/2');
L('F_trac/1', 'Grip limit/1');
L('F_grip/1', 'Grip limit/2');
L('Grip limit/1', 'Force balance/1');
L('F_roll/1', 'Force balance/2');
L('F_aero/1', 'Force balance/3');
L('Force balance/1', '1 over m_eq/1');
L('1 over m_eq/1', 'Integrator v/1');
L('Integrator v/1', 'v squared/1');
L('v squared/1', 'F_aero/1');
L('Integrator v/1', 'w_m from v/1');
L('Integrator v/1', 'v/1');
L('Motor + VESC limits/2', 'I_bat/1');
L('Motor + VESC limits/1', 'T_shaft/1');
L('Grip limit/1', 'F_wheel/1');
L('Motor + VESC limits/3', 'iq/1');

save_system(mdl, fullfile(out_dir, [mdl '.slx']));
fprintf('Built %s\n', fullfile(out_dir, [mdl '.slx']));

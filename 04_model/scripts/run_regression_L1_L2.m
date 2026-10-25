%% RUN_REGRESSION_L1_L2  L2 must reproduce L1 exactly while its hooks are empty.
%
%  Same parameters, same two manoeuvres, both models. Prints the largest
%  speed difference. Expected: ~0. Once a hook is filled, the difference is
%  the effect of that hook - and it should be explainable before it is run.

clear mot veh bat lim thr inv ctrl
here = fileparts(mfilename('fullpath'));
root = fullfile(here, '..');
run(fullfile(root, 'params', 'motor_params.m'));
run(fullfile(root, 'params', 'throttle_params.m'));
run(fullfile(root, 'params', 'vehicle_params.m'));

veh.m_total = veh.m_vehicle + veh.m_driver;
veh.m_eq = veh.m_total + veh.m_rot_wheels + mot.J * veh.i_gear^2 / veh.r_roll^2;
P = struct('p', mot.p, 'lambda', mot.lambda_m, 'Rs', mot.Rs, 'Lq', mot.Lq, ...
    'duty_max', lim.duty_max, 'i_batt_max', lim.i_batt_max, ...
    'T_c', mot.T_coulomb, 'b', mot.b_visc);
scns = {
    'full throttle', struct('t_end', 40, 'v0', 0, 'V_oc', 50, ...
        'throttle', timeseries([0 0 1 1]', [0 0.5 0.5001 40]'))
    'coast-down',    struct('t_end', 60, 'v0', 30/3.6, 'V_oc', 50, ...
        'throttle', timeseries([0 0]', [0 60]'))
    };
for s = 1:size(scns, 1)
    v = cell(1, 2);
    for m = 1:2
        mdl = sprintf('longitudinal_L%d', m);
        load_system(fullfile(root, 'models', [mdl '.slx']));
        in = Simulink.SimulationInput(mdl);
        in = in.setVariable('veh', veh).setVariable('bat', bat).setVariable('mot', mot) ...
            .setVariable('lim', lim).setVariable('thr', thr).setVariable('P', P) ...
            .setVariable('scn', scns{s, 2});
        o = sim(in);
        v{m} = o.yout{1}.Values;
    end
    t = linspace(0, scns{s, 2}.t_end, 2000)';
    dv = max(abs(interp1(v{1}.Time, v{1}.Data(:), t) - interp1(v{2}.Time, v{2}.Data(:), t)));
    fprintf('%-14s  max |v_L1 - v_L2| = %.2e km/h\n', scns{s, 1}, 3.6 * dv);
end

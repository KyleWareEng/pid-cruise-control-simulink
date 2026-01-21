%% Cruise Control System - Parameter Initialisation
% Run this script before simulating the Simulink model
% Author: Kyle Ware
% Date: January 2026
% Project: PID Cruise Control with Disturbance Rejection

clear; clc;

%% Vehicle Parameters
m = 1500;           % Vehicle mass [kg]
Cd = 0.3;           % Drag coefficient [-] (typical saloon car)
A = 2.2;            % Frontal area [m^2]
rho = 1.225;        % Air density at sea level [kg/m^3]

%% Rolling Resistance
Crr = 0.015;        % Rolling resistance coefficient [-]
g = 9.81;           % Gravitational acceleration [m/s^2]
F_roll = Crr * m * g;   % Constant rolling resistance force [N]

%% Reference Speed
v_target_mph = 70;              % Target speed [mph]
v_target = v_target_mph * 0.44704;  % Convert to [m/s] ≈ 31.3 m/s

%% Disturbance (Hill Simulation)
% Simulates a 3% gradient hill
gradient_percent = 3;           % Hill gradient [%]
theta = atan(gradient_percent/100);  % Gradient angle [rad]
F_hill = m * g * sin(theta);    % Hill resistance force [N] ≈ 441 N

%% PID Controller Gains (Initial Values)
Kp = 500;           % Proportional gain
Ki = 50;            % Integral gain
Kd = 100;           % Derivative gain

%% Simulation Parameters
T_sim = 60;         % Total simulation time [s]
T_hill = 10;        % Time when hill disturbance begins [s]

%% Actuator Limits
F_engine_max = 5000;    % Maximum engine force [N]
F_engine_min = 0;       % Minimum engine force [N] (no regenerative braking)

%% Display Parameters
fprintf('=== Cruise Control Parameters ===\n');
fprintf('Vehicle Mass: %.0f kg\n', m);
fprintf('Target Speed: %.1f m/s (%.0f mph)\n', v_target, v_target_mph);
fprintf('Rolling Resistance Force: %.1f N\n', F_roll);
fprintf('Hill Disturbance Force: %.1f N\n', F_hill);
fprintf('PID Gains: Kp=%.0f, Ki=%.0f, Kd=%.0f\n', Kp, Ki, Kd);
fprintf('================================\n');
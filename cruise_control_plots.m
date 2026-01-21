%% Publication-Quality Plots for PID Cruise Control System (FINAL)
% =========================================================================
% Author: Kyle Ware
% Course: Automotive Engineering MEng
% Project: PID Cruise Control with Disturbance Rejection
% Date: January 2026
% =========================================================================

close all;

%% ========================================================================
%  CONFIGURATION
%  ========================================================================

% Check if simulation data exists
if ~exist('out', 'var')
    error('Simulation data not found. Please run your Simulink model first.');
end

% Extract data from simulation output
try
    time = out.simout.Time;
    velocity = out.simout.Data;
catch
    error('Cannot read simulation data. Check your To Workspace block settings.');
end

% System parameters
v_target = 31.3;        % Target velocity [m/s]
v_target_mph = 70;      % Target velocity [mph]
m = 1500;               % Vehicle mass [kg]

% ACTUAL disturbance times (adjust these to match your simulation)
T_hill = 80;            % Uphill disturbance time [s]
T_downhill = 120;       % Downhill disturbance time [s]

% Plot styling
FONT_NAME = 'Arial';
FONT_SIZE_TITLE = 14;
FONT_SIZE_LABEL = 12;
FONT_SIZE_TICK = 10;
FONT_SIZE_LEGEND = 10;
LINE_WIDTH = 2;
LINE_WIDTH_THIN = 1.5;
LINE_WIDTH_REFERENCE = 1;

% Colours
COLOR_VELOCITY = [0, 0.4470, 0.7410];       % Blue
COLOR_TARGET = [0.8500, 0.3250, 0.0980];    % Orange/Red
COLOR_HILL = [0.8, 0.2, 0.2];               % Red
COLOR_DOWNHILL = [0.2, 0.6, 0.2];           % Green

%% ========================================================================
%  CREATE OUTPUT DIRECTORY
%  ========================================================================

output_dir = 'cruise_control_figures';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
    fprintf('Created output directory: %s/\n', output_dir);
end

%% ========================================================================
%  FIGURE 1: Main Velocity Response Plot
%  ========================================================================

fig1 = figure('Name', 'Velocity Response', ...
              'Position', [100, 100, 900, 550], ...
              'Color', 'white', ...
              'PaperPositionMode', 'auto');

plot(time, velocity, 'Color', COLOR_VELOCITY, 'LineWidth', LINE_WIDTH);
hold on;
yline(v_target, '--', 'Color', COLOR_TARGET, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_hill, ':', 'Color', COLOR_HILL, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_downhill, ':', 'Color', COLOR_DOWNHILL, 'LineWidth', LINE_WIDTH_REFERENCE);

xlabel('Time (s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL, 'FontWeight', 'bold');
ylabel('Velocity (m/s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL, 'FontWeight', 'bold');
title('PID Cruise Control: Velocity Response with Disturbance Rejection', ...
      'FontName', FONT_NAME, 'FontSize', FONT_SIZE_TITLE, 'FontWeight', 'bold');

ax = gca;
ax.FontName = FONT_NAME;
ax.FontSize = FONT_SIZE_TICK;
ax.Box = 'on';
xlim([0, max(time)]);
ylim([0, 45]);
grid on;
ax.GridAlpha = 0.3;

legend({'Actual Velocity', sprintf('Target (%.1f m/s = %d mph)', v_target, v_target_mph), ...
        sprintf('Uphill (t=%ds)', T_hill), sprintf('Downhill (t=%ds)', T_downhill)}, ...
       'Location', 'northeast', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LEGEND);

text(T_hill + 2, 24, {'Uphill', sprintf('(t=%ds)', T_hill)}, ...
     'FontName', FONT_NAME, 'FontSize', 9, 'Color', COLOR_HILL);
text(T_downhill + 2, 24, {'Downhill', sprintf('(t=%ds)', T_downhill)}, ...
     'FontName', FONT_NAME, 'FontSize', 9, 'Color', COLOR_DOWNHILL);

hold off;

% Save Figure 1
saveas(fig1, fullfile(output_dir, 'fig1_velocity_response.png'));
saveas(fig1, fullfile(output_dir, 'fig1_velocity_response.fig'));
print(fig1, fullfile(output_dir, 'fig1_velocity_response_hires'), '-dpng', '-r300');
fprintf('Saved: Figure 1 - Velocity Response\n');

%% ========================================================================
%  FIGURE 2: Detailed Analysis
%  ========================================================================

fig2 = figure('Name', 'Detailed Analysis', ...
              'Position', [150, 50, 1000, 700], ...
              'Color', 'white', ...
              'PaperPositionMode', 'auto');

% --- Panel 1: Full response ---
subplot(2, 2, [1, 2]);
plot(time, velocity, 'Color', COLOR_VELOCITY, 'LineWidth', LINE_WIDTH);
hold on;
yline(v_target, '--', 'Color', COLOR_TARGET, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_hill, ':', 'Color', COLOR_HILL, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_downhill, ':', 'Color', COLOR_DOWNHILL, 'LineWidth', LINE_WIDTH_REFERENCE);

% Shaded regions
fill([0 T_hill T_hill 0], [0 0 45 45], 'g', 'FaceAlpha', 0.05, 'EdgeColor', 'none');
fill([T_hill T_downhill T_downhill T_hill], [0 0 45 45], 'r', 'FaceAlpha', 0.05, 'EdgeColor', 'none');
fill([T_downhill max(time) max(time) T_downhill], [0 0 45 45], 'b', 'FaceAlpha', 0.05, 'EdgeColor', 'none');

xlabel('Time (s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
ylabel('Velocity (m/s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
title('Complete System Response', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_TITLE, 'FontWeight', 'bold');
xlim([0, max(time)]);
ylim([0, 45]);
grid on;
ax = gca; ax.GridAlpha = 0.3; ax.FontSize = FONT_SIZE_TICK;

text(T_hill/2, 43, 'Acceleration & Settling', 'HorizontalAlignment', 'center', ...
     'FontName', FONT_NAME, 'FontSize', 10, 'FontWeight', 'bold');
text((T_hill + T_downhill)/2, 43, 'Uphill', 'HorizontalAlignment', 'center', ...
     'FontName', FONT_NAME, 'FontSize', 10, 'FontWeight', 'bold', 'Color', COLOR_HILL);
text((T_downhill + max(time))/2, 43, 'Downhill', 'HorizontalAlignment', 'center', ...
     'FontName', FONT_NAME, 'FontSize', 10, 'FontWeight', 'bold', 'Color', COLOR_DOWNHILL);

legend({'Velocity', 'Target', 'Uphill Start', 'Downhill Start'}, 'Location', 'northeast');
hold off;

% --- Panel 2: Initial transient ---
subplot(2, 2, 3);
idx_transient = time <= 60;
plot(time(idx_transient), velocity(idx_transient), 'Color', COLOR_VELOCITY, 'LineWidth', LINE_WIDTH);
hold on;
yline(v_target, '--', 'Color', COLOR_TARGET, 'LineWidth', LINE_WIDTH_REFERENCE);
yline(0.9 * v_target, ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
yline(1.02 * v_target, ':', 'Color', [0.8 0.2 0.2], 'LineWidth', 1);
yline(0.98 * v_target, ':', 'Color', [0.8 0.2 0.2], 'LineWidth', 1);

xlabel('Time (s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
ylabel('Velocity (m/s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
title('Initial Transient Response', 'FontName', FONT_NAME, 'FontSize', 12, 'FontWeight', 'bold');
xlim([0, 60]);
ylim([0, 45]);
grid on;
ax = gca; ax.GridAlpha = 0.3; ax.FontSize = FONT_SIZE_TICK;

text(55, 0.9*v_target + 1.5, '90%', 'FontSize', 8, 'Color', [0.5 0.5 0.5]);
text(55, 1.02*v_target + 1.5, '+2%', 'FontSize', 8, 'Color', [0.8 0.2 0.2]);

legend({'Velocity', 'Target', '90% Line', '+/-2% Band'}, 'Location', 'northeast', 'FontSize', 8);
hold off;

% --- Panel 3: Disturbance rejection ---
subplot(2, 2, 4);
t_start = T_hill - 10;
t_end = min(T_downhill + 40, max(time));
idx_disturb = (time >= t_start) & (time <= t_end);
plot(time(idx_disturb), velocity(idx_disturb), 'Color', COLOR_VELOCITY, 'LineWidth', LINE_WIDTH);
hold on;
yline(v_target, '--', 'Color', COLOR_TARGET, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_hill, ':', 'Color', COLOR_HILL, 'LineWidth', LINE_WIDTH_THIN);
xline(T_downhill, ':', 'Color', COLOR_DOWNHILL, 'LineWidth', LINE_WIDTH_THIN);

fill([t_start t_end t_end t_start], [0.98*v_target 0.98*v_target 1.02*v_target 1.02*v_target], ...
     'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

xlabel('Time (s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
ylabel('Velocity (m/s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
title('Disturbance Rejection Detail', 'FontName', FONT_NAME, 'FontSize', 12, 'FontWeight', 'bold');
xlim([t_start, t_end]);
ylim([25, 36]);
grid on;
ax = gca; ax.GridAlpha = 0.3; ax.FontSize = FONT_SIZE_TICK;

text(T_hill + 1, 35, 'Uphill', 'FontSize', 9, 'Color', COLOR_HILL, 'FontWeight', 'bold');
text(T_downhill + 1, 35, 'Downhill', 'FontSize', 9, 'Color', COLOR_DOWNHILL, 'FontWeight', 'bold');

legend({'Velocity', 'Target', '', '', '+/-2% Band'}, 'Location', 'northeast', 'FontSize', 8);
hold off;

sgtitle('PID Cruise Control System - Performance Analysis', ...
        'FontName', FONT_NAME, 'FontSize', 16, 'FontWeight', 'bold');

% Save Figure 2
saveas(fig2, fullfile(output_dir, 'fig2_detailed_analysis.png'));
saveas(fig2, fullfile(output_dir, 'fig2_detailed_analysis.fig'));
print(fig2, fullfile(output_dir, 'fig2_detailed_analysis_hires'), '-dpng', '-r300');
fprintf('Saved: Figure 2 - Detailed Analysis\n');

%% ========================================================================
%  CALCULATE PERFORMANCE METRICS
%  ========================================================================

% Rise time (10% to 90%)
idx_10 = find(velocity >= 0.1 * v_target, 1, 'first');
idx_90 = find(velocity >= 0.9 * v_target, 1, 'first');
if ~isempty(idx_10) && ~isempty(idx_90)
    rise_time = time(idx_90) - time(idx_10);
else
    rise_time = NaN;
end

% Overshoot
max_velocity = max(velocity);
overshoot_pct = (max_velocity - v_target) / v_target * 100;

% Settling time (when first enters and stays in 2% band before disturbance)
tolerance = 0.02 * v_target;
idx_pre_hill = time < T_hill;
pre_hill_vel = velocity(idx_pre_hill);
pre_hill_time = time(idx_pre_hill);
in_band = abs(pre_hill_vel - v_target) <= tolerance;
if any(in_band)
    settling_time = pre_hill_time(find(in_band, 1, 'first'));
else
    settling_time = NaN;
end

% Steady-state error
ss_velocity = mean(velocity(end-20:end));
ss_error = abs(v_target - ss_velocity);
ss_error_pct = ss_error / v_target * 100;

% Uphill metrics
idx_hill_start = find(time >= T_hill, 1, 'first');
idx_hill_end = find(time >= T_downhill, 1, 'first');
if ~isempty(idx_hill_start) && ~isempty(idx_hill_end)
    hill_vel = velocity(idx_hill_start:idx_hill_end);
    hill_min = min(hill_vel);
    hill_drop = v_target - hill_min;
    hill_drop_pct = hill_drop / v_target * 100;
else
    hill_drop = NaN;
    hill_drop_pct = NaN;
end

% Downhill metrics
idx_down_start = find(time >= T_downhill, 1, 'first');
if ~isempty(idx_down_start)
    down_vel = velocity(idx_down_start:end);
    down_max = max(down_vel);
    down_rise = down_max - v_target;
    down_rise_pct = down_rise / v_target * 100;
else
    down_rise = NaN;
    down_rise_pct = NaN;
end

%% ========================================================================
%  FIGURE 3: Summary Dashboard
%  ========================================================================

fig3 = figure('Name', 'Summary Dashboard', ...
              'Position', [200, 100, 1100, 650], ...
              'Color', 'white', ...
              'PaperPositionMode', 'auto');

% Left: Plot
subplot(1, 2, 1);
plot(time, velocity, 'Color', COLOR_VELOCITY, 'LineWidth', LINE_WIDTH);
hold on;
yline(v_target, '--', 'Color', COLOR_TARGET, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_hill, ':', 'Color', COLOR_HILL, 'LineWidth', LINE_WIDTH_REFERENCE);
xline(T_downhill, ':', 'Color', COLOR_DOWNHILL, 'LineWidth', LINE_WIDTH_REFERENCE);
xlabel('Time (s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
ylabel('Velocity (m/s)', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_LABEL);
title('System Response', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_TITLE, 'FontWeight', 'bold');
xlim([0, max(time)]);
ylim([0, 45]);
grid on;
legend({'Actual', 'Target', 'Uphill', 'Downhill'}, 'Location', 'northeast');
hold off;

% Right: Metrics
subplot(1, 2, 2);
axis off;

metrics_text = {
    '─────────────────────────────────────'
    'SYSTEM PARAMETERS'
    '─────────────────────────────────────'
    sprintf('  Target Velocity:    %.1f m/s (%d mph)', v_target, v_target_mph)
    sprintf('  Vehicle Mass:       %d kg', m)
    sprintf('  Uphill at:          t = %d s', T_hill)
    sprintf('  Downhill at:        t = %d s', T_downhill)
    ''
    '─────────────────────────────────────'
    'TRANSIENT RESPONSE'
    '─────────────────────────────────────'
    sprintf('  Rise Time (10-90%%): %.2f s', rise_time)
    sprintf('  Overshoot:          %.1f%%', overshoot_pct)
    sprintf('  Settling Time (2%%): %.2f s', settling_time)
    ''
    '─────────────────────────────────────'
    'UPHILL DISTURBANCE REJECTION'
    '─────────────────────────────────────'
    sprintf('  Max Speed Drop:     %.2f m/s (%.1f%%)', hill_drop, hill_drop_pct)
    ''
    '─────────────────────────────────────'
    'DOWNHILL DISTURBANCE REJECTION'
    '─────────────────────────────────────'
    sprintf('  Max Speed Rise:     %.2f m/s (%.1f%%)', down_rise, down_rise_pct)
    ''
    '─────────────────────────────────────'
    'STEADY-STATE PERFORMANCE'
    '─────────────────────────────────────'
    sprintf('  Final Velocity:     %.2f m/s', ss_velocity)
    sprintf('  Steady-State Error: %.4f m/s (%.3f%%)', ss_error, ss_error_pct)
};

text(0.05, 0.98, metrics_text, ...
     'FontName', 'Courier New', 'FontSize', 9, ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');

title('Performance Metrics', 'FontName', FONT_NAME, 'FontSize', FONT_SIZE_TITLE, 'FontWeight', 'bold');

sgtitle('PID Cruise Control - Project Summary', ...
        'FontName', FONT_NAME, 'FontSize', 16, 'FontWeight', 'bold');

% Save Figure 3
saveas(fig3, fullfile(output_dir, 'fig3_summary_dashboard.png'));
saveas(fig3, fullfile(output_dir, 'fig3_summary_dashboard.fig'));
print(fig3, fullfile(output_dir, 'fig3_summary_dashboard_hires'), '-dpng', '-r300');
fprintf('Saved: Figure 3 - Summary Dashboard\n');

%% ========================================================================
%  PRINT SUMMARY
%  ========================================================================

fprintf('\n========================================\n');
fprintf('PERFORMANCE METRICS SUMMARY\n');
fprintf('========================================\n');
fprintf('Target Velocity:     %.1f m/s (%d mph)\n', v_target, v_target_mph);
fprintf('Vehicle Mass:        %d kg\n', m);
fprintf('----------------------------------------\n');
fprintf('TRANSIENT RESPONSE\n');
fprintf('  Rise Time (10-90%%):  %.2f s\n', rise_time);
fprintf('  Peak Overshoot:      %.1f%%\n', overshoot_pct);
fprintf('  Settling Time (2%%):  %.2f s\n', settling_time);
fprintf('----------------------------------------\n');
fprintf('UPHILL DISTURBANCE (t = %ds)\n', T_hill);
fprintf('  Max Speed Drop:      %.2f m/s (%.1f%%)\n', hill_drop, hill_drop_pct);
fprintf('----------------------------------------\n');
fprintf('DOWNHILL DISTURBANCE (t = %ds)\n', T_downhill);
fprintf('  Max Speed Rise:      %.2f m/s (%.1f%%)\n', down_rise, down_rise_pct);
fprintf('----------------------------------------\n');
fprintf('STEADY-STATE PERFORMANCE\n');
fprintf('  Final Velocity:      %.2f m/s\n', ss_velocity);
fprintf('  Steady-State Error:  %.4f m/s (%.3f%%)\n', ss_error, ss_error_pct);
fprintf('========================================\n');

%% ========================================================================
%  CONFIRM FILES SAVED
%  ========================================================================

fprintf('\n========================================\n');
fprintf('FILES SAVED TO: %s/\n', fullfile(pwd, output_dir));
fprintf('========================================\n');
fprintf('  fig1_velocity_response.png\n');
fprintf('  fig1_velocity_response.fig\n');
fprintf('  fig1_velocity_response_hires.png (300 DPI)\n');
fprintf('  fig2_detailed_analysis.png\n');
fprintf('  fig2_detailed_analysis.fig\n');
fprintf('  fig2_detailed_analysis_hires.png (300 DPI)\n');
fprintf('  fig3_summary_dashboard.png\n');
fprintf('  fig3_summary_dashboard.fig\n');
fprintf('  fig3_summary_dashboard_hires.png (300 DPI)\n');
fprintf('========================================\n');
fprintf('Total: 9 files saved successfully!\n');
fprintf('========================================\n');
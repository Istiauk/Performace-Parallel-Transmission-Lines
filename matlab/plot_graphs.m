% plot_graphs.m
% Generates the six graphs of the report (load vs %eff and I_E vs U_E / I_A for
% each of the three cases) and saves them as PNG files (300 dpi).
clear; clc; close all;
lab_data;
cases = {c1, c2, c3};
names = {'with capacitors', 'without capacitors', 'line 1 disconnected (with capacitor)'};
tag   = {'case1', 'case2', 'case3'};

for n = 1:3
    c = cases{n};

    % ---------- Load vs %efficiency ----------
    f = figure('Color','w','Position',[100 100 700 480]);
    [xs, idx] = sort(loadR);
    plot(xs, c.eff(idx), '-o', 'LineWidth', 1.8, 'MarkerSize', 7, ...
         'MarkerFaceColor', 'w', 'Color', [0 0.2 0.7]);
    grid on; box on;
    xlabel('Load (\Omega)', 'FontSize', 12);
    ylabel('Efficiency, \eta (%)', 'FontSize', 12);
    title(sprintf('Load vs %%\\eta - parallel lines %s', names{n}), 'FontSize', 12);
    xlim([0 1100]); ylim([floor(min(c.eff)-3) ceil(max(c.eff)+2)]);
    print(f, sprintf('graph_%s_load_vs_eff.png', tag{n}), '-dpng', '-r300');

    % ---------- I_E vs U_E and I_E vs I_A (two y axes) ----------
    f = figure('Color','w','Position',[100 100 700 480]);
    yyaxis left
    plot(c.IE, c.VE, '-o', 'LineWidth', 1.8, 'MarkerSize', 7, 'MarkerFaceColor', 'w');
    ylabel('U_E (V)', 'FontSize', 12);
    ylim([100 250]);
    yyaxis right
    plot(c.IE, c.IA, '-s', 'LineWidth', 1.8, 'MarkerSize', 7, 'MarkerFaceColor', 'w');
    ylabel('I_A (A)', 'FontSize', 12);
    ylim([0 1]);
    grid on; box on;
    xlabel('I_E (A)', 'FontSize', 12);
    title(sprintf('I_E vs U_E and I_A - parallel lines %s', names{n}), 'FontSize', 12);
    legend({'U_E vs I_E', 'I_A vs I_E'}, 'Location', 'best');
    xlim([0 1.1]);
    print(f, sprintf('graph_%s_IE_vs_UE.png', tag{n}), '-dpng', '-r300');
end
disp('Done: 6 PNG graphs saved in the current folder.');

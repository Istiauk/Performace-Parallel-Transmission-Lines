% phasor_simplified.m
% Phasor diagram of the SIMPLIFIED equivalent circuit (two lines in parallel
% replaced by Z_tot = R_tot + jX_tot, shunt elements neglected).
%   VA = VE + R_tot*I_AE + j*X_tot*I_AE        (here I_AE = IE)
% Built to scale from the measured data of the "parallel lines without
% capacitors" case.  Change k (1..5) to choose the load step R_k-L_k.
clear; clc; close all;
lab_data;
k = 5;                                   % load step to draw (R5-L5 = heaviest load)

c = c2;                                  % case 2: without capacitors
[R, X, ~, err] = fit_line_params(c, Vph, false);   % B forced to 0 (no shunt)
fprintf('Estimated Z_tot = %.2f + j%.2f ohm   (fit rms error %.3f)\n', R, X, err);

VE  = c.VE(k);                           % reference phasor (angle 0)
phi = atan2(c.Q2(k), c.P2(k));           % load angle from measured P2, Q2 (lagging)
IE  = c.IE(k)*exp(-1j*phi);
VR  = R*IE;                              % R_tot * I_AE
VX  = 1j*X*IE;                           % jX_tot * I_AE
VA  = VE + VR + VX;
fprintf('Load step %d: |VA| (computed) = %.1f V (measured %.1f V), angle(VA) = %.2f deg\n', ...
        k, abs(VA), Vph, rad2deg(angle(VA)));

kI = 0.55*abs(VE)/abs(IE);               % current scale: 1 A drawn as kI volts

figure('Color','w','Position',[100 100 900 560]); ax = axes; hold(ax,'on');
draw_phasor(ax, 0, VA,    [0 0 0],       'V_A',      2);
draw_phasor(ax, 0, VE,    [0 0.2 0.8],   'V_E',      2);
draw_phasor(ax, VE, VR,   [0.85 0.33 0.1], 'R_{tot}\cdotI_{AE}', 2, -4i);
draw_phasor(ax, VE+VR, VX,[0.1 0.55 0.1], 'jX_{tot}\cdotI_{AE}', 2, 6);
draw_phasor(ax, 0, IE*kI, [0.7 0 0.5],   'I_E',      2);
axis(ax,'equal'); axis(ax,'off');
xlim(ax,[-10 abs(VA)*1.08]); ylim(ax,[-abs(IE*kI)*1.05 abs(VX)*1.6]);
% angle arc between VE and IE (load angle phi)
t = linspace(0,-phi,40); r = 0.18*abs(VE);
plot(ax, r*cos(t), r*sin(t), 'k-', 'LineWidth', 0.8);
text(ax, r*1.1, -r*0.35, '\phi_2', 'FontSize', 12);
title(ax, sprintf('Phasor diagram - simplified equivalent circuit (R%d-L%d)', k, k), 'FontSize', 13);
annotation('textbox',[0.12 0.02 0.8 0.06],'String', ...
    sprintf('Current drawn with scale 1 A = %.0f V (voltages to scale)', kI), ...
    'EdgeColor','none','FontSize',10);
print(gcf, 'phasor_simplified.png', '-dpng', '-r300');

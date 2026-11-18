% phasor_with_shunt.m
% Phasor diagram of the equivalent circuit WITH shunt (capacitive) elements.
%   I_AE = IE + (I_E01 + I_E02)         I_E01+I_E02 = jB*VE   (receiving-end shunt)
%   VA   = VE + R_tot*I_AE + jX_tot*I_AE
%   IA   = I_AE + (I_A01 + I_A02)       I_A01+I_A02 = jB*VA   (sending-end shunt)
% Built to scale from the measured data of the "parallel lines WITH capacitors"
% case.  R_tot, X_tot and B are estimated by fitting the whole data set.
clear; clc; close all;
lab_data;
k = 3;                                   % load step to draw (1..5)

c = c1;                                  % case 1: with capacitors
[R, X, B, err] = fit_line_params(c, Vph, true);
fprintf('Estimated Z_tot = %.2f + j%.2f ohm, shunt B = %.3e S per end (rms err %.3f)\n', R, X, B, err);

VE  = c.VE(k);
phi = atan2(c.Q2(k), c.P2(k));
IE  = c.IE(k)*exp(-1j*phi);
IcE = 1j*B*VE;                           % I_E01 + I_E02
IAE = IE + IcE;
VR  = R*IAE;   VX = 1j*X*IAE;
VA  = VE + VR + VX;
IcA = 1j*B*VA;                           % I_A01 + I_A02
IA  = IAE + IcA;

S1 = VA*conj(IA);
fprintf('Load step %d: |VA| = %.1f V (measured %.1f), |IA| = %.3f A (table I1+I2 = %.3f)\n', ...
        k, abs(VA), Vph, abs(IA), c.IA(k));
fprintf('              P1 = %.1f W (measured %.1f), Q1 = %.1f var (measured %.1f)\n', ...
        real(S1), c.P1(k), imag(S1), c.Q1(k));

kI = 0.55*abs(VE)/abs(IA);               % current scale

figure('Color','w','Position',[100 100 950 600]); ax = axes; hold(ax,'on');
draw_phasor(ax, 0, VA,  [0 0 0],        'V_A', 2);
draw_phasor(ax, 0, VE,  [0 0.2 0.8],    'V_E', 2);
draw_phasor(ax, VE, VR, [0.85 0.33 0.1],'R_{tot}\cdotI_{AE}', 2, -4i);
draw_phasor(ax, VE+VR, VX,[0.1 0.55 0.1],'jX_{tot}\cdotI_{AE}', 2, 6);
draw_phasor(ax, 0, IA*kI,  [0.5 0 0.5], 'I_A',  2, 8i);
draw_phasor(ax, 0, IAE*kI, [0.7 0 0.3], 'I_{AE}', 2, -8i);
draw_phasor(ax, 0, IE*kI,  [0.4 0 0.7], 'I_E',  2, -8i);
draw_phasor(ax, IE*kI,  IcE*kI, [0.9 0.5 0], 'I_{E01}+I_{E02}', 1.8, 5);
draw_phasor(ax, IAE*kI, IcA*kI, [0 0.6 0.6], 'I_{A01}+I_{A02}', 1.8, 5);
axis(ax,'equal'); axis(ax,'off');
xlim(ax,[-10 abs(VA)*1.08]); ylim(ax,[-abs(IE*kI)*1.1 max(abs(VX)*1.6, abs(IA*kI)*1.1)]);
title(ax, sprintf('Phasor diagram - equivalent circuit with shunt elements (R%d-L%d)', k, k), 'FontSize', 13);
annotation('textbox',[0.12 0.02 0.8 0.06],'String', ...
    sprintf('Current drawn with scale 1 A = %.0f V (voltages to scale)', kI), ...
    'EdgeColor','none','FontSize',10);
print(gcf, 'phasor_with_shunt.png', '-dpng', '-r300');

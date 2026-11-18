function [R, X, B, rmsErr] = fit_line_params(c, Vph, fitB)
% FIT_LINE_PARAMS  Estimate the equivalent series impedance Z_tot = R + jX and
% the shunt susceptance B (same at both ends) of the two parallel lines from
% the measured data of one case (struct c).  fitB = false forces B = 0.
%
% Model (per phase, pi-equivalent, receiving-end values as reference):
%   VE   = |VE| at 0 deg
%   IE   = |IE| at -atan2(Q2,P2)
%   I_AE = IE + jB*VE         VA = VE + (R+jX)*I_AE
%   IA   = I_AE + jB*VA       S1 = VA*conj(IA)  -> must match P1 + jQ1, |VA| = Vph
    if nargin < 3, fitB = true; end
    n = numel(c.VE);
    cost = @(p) sum(resid(p, c, Vph, n, fitB).^2);
    opts = optimset('TolX',1e-10,'TolFun',1e-12,'MaxIter',20000,'MaxFunEvals',20000);
    best = Inf;
    starts = [14 52 1; 10 30 0.5; 30 100 2];
    for s = 1:size(starts,1)
        [p, f] = fminsearch(cost, starts(s,:), opts);
        if f < best, best = f; pbest = p; end
    end
    R = pbest(1); X = pbest(2);
    if fitB, B = pbest(3)*1e-3; else, B = 0; end
    rmsErr = sqrt(best/(3*n));
end

function r = resid(p, c, Vph, n, fitB)
    R = p(1); X = p(2);
    if fitB, B = p(3)*1e-3; else, B = 0; end
    r = zeros(1,3*n);
    for k = 1:n
        ve  = c.VE(k);
        ie  = c.IE(k)*exp(-1j*atan2(c.Q2(k), c.P2(k)));
        iae = ie + 1j*B*ve;
        va  = ve + (R+1j*X)*iae;
        ia  = iae + 1j*B*va;
        s1  = va*conj(ia);
        r(3*k-2) = (abs(va)-Vph)/Vph*10;
        r(3*k-1) = (real(s1)-c.P1(k))/10;
        r(3*k)   = (imag(s1)-c.Q1(k))/10;
    end
end

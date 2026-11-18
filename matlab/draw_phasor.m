function draw_phasor(ax, p0, v, col, lbl, lw, lblOffset)
% DRAW_PHASOR  Draw phasor v (complex, in volt-scaled units) starting at p0
% with a fixed-size arrow head, and put a label at its middle.
    if nargin < 6, lw = 1.8; end
    if nargin < 7, lblOffset = 0; end
    u    = v/abs(v);                      % unit direction
    hl   = min(7, 0.4*abs(v));            % arrow-head length
    hw   = hl*0.38;                       % arrow-head half width
    tip  = p0 + v;
    base = tip - hl*u;
    plot(ax, [real(p0) real(base)], [imag(p0) imag(base)], '-', 'Color', col, 'LineWidth', lw);
    hd = [tip, base + 1i*u*hw, base - 1i*u*hw];
    fill(ax, real(hd), imag(hd), col, 'EdgeColor', col);
    pm = p0 + v/2 + lblOffset;
    text(ax, real(pm), imag(pm), lbl, 'Color', col, 'FontSize', 12, ...
         'FontWeight', 'bold', 'Interpreter', 'tex', 'BackgroundColor', 'w', ...
         'HorizontalAlignment', 'center', 'Margin', 1);
end

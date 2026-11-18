% run_all.m
% Regenerates every figure of the project (6 graphs + 2 phasor diagrams).
% Run from this folder:  >> run_all
% PNGs are written to the current folder at 300 dpi.
plot_graphs;
phasor_simplified;
phasor_with_shunt;
disp('All figures regenerated.');

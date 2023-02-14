function PlotGroundReaction_MC(time, fplate,legend_name)
figure();
subplot(211)
PlotGraphGRF(fplate(1).Data(:,2), time, 'GRF Horizontal Component - Plate 1');
subplot(212)
PlotGraphGRF(fplate(1).Data(:,3), time, 'GRF Vertical Component - Plate 1');
legend(legend_name);

end
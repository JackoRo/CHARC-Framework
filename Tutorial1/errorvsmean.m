cw = [genotype.connectWeights];
for i = 1:length(cw)
 mean_cw(i) = mean(mean(full(cw{i})));
end

x = mean_cw.*[esn.spectralRadius];
y = [genotype.testError];
c = [esn.inputScaling];

figure
scatter(x,y,40,c,'filled','MarkerEdgeColor',[0 .5 .5])
grid on
xlabel('Mean(W) x Spectral Radius')
ylabel('Test error')
colormap(colorcube)
colorbar
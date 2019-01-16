x = [genotype.testError];
y = [esn.spectralRadius];
c = [esn.inputScaling];

figure
scatter(x,y,40,c,'filled')
grid on
esn = [genotype.esnMinor];  %group ESNs together
x = [genotype.testError];   %extract all test errors
y = [esn.spectralRadius];   %extract spectal radius

figure
scatter(x,y)
grid on

xlabel('Test error')
ylabel('Spectral Radius')
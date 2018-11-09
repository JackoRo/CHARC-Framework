function genotype =createDeepReservoir_ensemble(config)



%% Reservoir Parameters
for res = 1:config.popSize
    % Assign neuron/model type (options: 'plain' and 'leaky', so far... 'feedback', 'multinetwork', 'LeakyBias')
    genotype(res).trainError = 1;
    genotype(res).valError = 1;
    genotype(res).testError = 1;
    
    genotype(res).inputShift = 1;
    
    if config.startFull
        config.minMajorUnits = config.maxMajorUnits; %maxMinorUnits = 100;
        config.minMinorUnits = config.maxMinorUnits;
    else
        config.minMajorUnits = 1;
        config.minMinorUnits = 2;
    end
    
    genotype(res).nInternalUnits = randi([config.minMajorUnits config.maxMajorUnits]);
    
    if isempty(config.trainInputSequence)
        genotype(res).nInputUnits = 1;
        genotype(res).nOutputUnits = 1;
    else
        genotype(res).nInputUnits = size(config.trainInputSequence,2);
        genotype(res).nOutputUnits = size(config.trainOutputSequence,2);
    end
    
    % rand number of inner ESN's
    for i = 1:  genotype(res).nInternalUnits
        
        %define num of units
        genotype(res).esnMinor(i).nInternalUnits = randi([config.minMinorUnits config.maxMinorUnits]);
        %store(i) = genotype.esnMinor(i).nInternalUnits;
        
        % Scaling
        genotype(res).esnMinor(i).spectralRadius = 2*rand; %alters network dynamics and memory, SR < 1 in almost all cases
        genotype(res).esnMinor(i).inputScaling = 2*rand-1; %increases nonlinearity
        genotype(res).esnMinor(i).inputShift = 1; %adds bias/value shift to input signal
        genotype(res).esnMinor(i).leakRate = rand;
        
        %inputweights
        if config.sparseInputWeights
            inputWeights = sprand(genotype(res).esnMinor(i).nInternalUnits,  genotype(res).nInputUnits+1, 0.1);
            inputWeights(inputWeights ~= 0) = ...
                2*inputWeights(inputWeights ~= 0)  - 1;
            genotype(res).esnMinor(i).inputWeights = inputWeights;
        else
            genotype(res).esnMinor(i).inputWeights = 2*rand(genotype(res).esnMinor(i).nInternalUnits,  genotype(res).nInputUnits+1)-1; %1/genotype.esnMinor(res,i).nInternalUnits
        end
        
        %initialise new reservoir
        %genotype.esnMinor(res,i).connectRatio = round(rand*10)*10;
        genotype(res).esnMinor(i).connectivity = 10/genotype(res).esnMinor(i).nInternalUnits; %max([10/genotype.esnMinor(res,i).nInternalUnits rand]);%min([10/genotype.esnMinor(res,i).nInternalUnits 1]);
        genotype(res).esnMinor(i).internalWeights_UnitSR = generate_internal_weights(genotype(res).esnMinor(i).nInternalUnits, ...
            genotype(res).esnMinor(i).connectivity);
        %genotype.esnMinor(res,i).rho = genotype.esnMinor(i).internalWeights_UnitSR;%/max(abs(eigs(genotype.esnMinor(res,i).internalWeights_UnitSR)));
        genotype(res).esnMinor(i).internalWeights = genotype(res).esnMinor(i).spectralRadius * genotype(res).esnMinor(i).internalWeights_UnitSR;
        genotype(res).esnMinor(i).outputWeights = zeros( genotype(res).nOutputUnits, genotype(res).esnMinor(i).nInternalUnits +  genotype(res).nInputUnits);
        
        if config.multiActiv
            activPositions = randi(length(config.ActivList),1,genotype(res).esnMinor(i).nInternalUnits);
            for act = 1:length(activPositions)
                genotype(res).reservoirActivationFunction{i,act} = config.ActivList{activPositions(act)};
            end
        else
            genotype(res).reservoirActivationFunction = 'tanh';
            
        end
    end
    
    genotype(res).Nunits = 0;
    
    %% connectivity to other reservoirs
    for i= 1: genotype(res).nInternalUnits
        for j= 1: genotype(res).nInternalUnits
            
            genotype(res).InnerConnectivity = 1;
            val = (2*rand-1);%/10;
            genotype(res).interResScaling{i,j} = val;
            
            if i==j %new
                genotype(res).connectWeights{i,j} = genotype(res).esnMinor(i).internalWeights;
                genotype(res).interResScaling{i,j} = 1;
            else
                genotype(res).connectWeights{i,j} =  0;
                genotype(res).connectWeights{j,i} = 0;
            end
        end
        genotype(res).Nunits = genotype(res).Nunits + genotype(res).esnMinor(i).nInternalUnits; 
    end
          
          if config.AddInputStates
        genotype(res).outputWeights = zeros(genotype(res).Nunits+genotype(res).nInputUnits+1,genotype(res).nOutputUnits);      
    else
        genotype(res).outputWeights = zeros(genotype(res).Nunits+1,genotype(res).nOutputUnits);
    end
end
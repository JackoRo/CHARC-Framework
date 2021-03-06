function esn = addWeight(esn,type)

switch(type)
    case 'input'
        
        insertX = randi([1 size(esn.inputWeights,1)]);
        insertY = randi([1 size(esn.inputWeights,2)]);
        
        esn.inputWeights(insertX,insertY) = 2*rand-1;
        
        
    case 'internal'
        
        locX = randi([1 size(esn.internalWeights_UnitSR,1)]);
        locY = randi([1 size(esn.internalWeights_UnitSR,1)]);
        
        value = rand-0.5;
        esn.internalWeights_UnitSR(locX,locY) = value;
        esn.internalWeights(locX,locY) = value*esn.spectralRadius;
        
    case 'interConnect'
        
        %if ~isempty(esn)
            locX = randi([1 size(esn,1)]);
            locY = randi([1 size(esn,2)]);
            
            esn(locX,locY) = rand-0.5;
        %end
end
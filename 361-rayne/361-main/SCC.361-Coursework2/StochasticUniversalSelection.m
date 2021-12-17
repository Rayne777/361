function choice = StochasticUniversalSelection(weights)
    keep=[];
    accumulation = cumsum(weights);
   for i =1:length(weights)
     if(accumulation(i)<weights)
        keep.add(population)
     end
   end
  choice = keep;
end
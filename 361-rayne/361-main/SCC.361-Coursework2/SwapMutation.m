% applies Flip Mutation to chromosome 
% 2 random points are chosen and the values between flipped
function swappedChromosome = SwapMutation(chromosome)
 point1 = randi([1, length(chromosome)]);
 point2 = randi([1, length(chromosome)]);
 while(point2 == point1)
 point2 = randi([1, length(chromosome)]);
 end
 [chromosome(point1), chromosome(point2)] = swap(chromosome(point1), chromosome(point2));
 swappedChromosome = chromosome;
end

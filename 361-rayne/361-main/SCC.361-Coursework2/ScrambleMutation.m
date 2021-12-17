
function scrambleChromosome = ScrambleMutation(chromosome)
    point1 = randi([1, length(chromosome)]);
    point2 = randi([1, length(chromosome)]);
    while(point1>=point2)
        point1 = randi([1, length(chromosome)]);
        point2 = randi([1, length(chromosome)]);
    end 
    len = chromosome(point1:point2);
    a =length(len);
    flip = len(randperm(a));
    chromosome(point1:point2) = flip;
    scrambleChromosome =chromosome;
end
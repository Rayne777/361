
function scrambleChromosome = ScrambleMutation(chromosome)
    point1 = randi([1, length(chromosome)]);
    point2 = randi([1, length(chromosome)]);
    while(point1>=point2)
        point1 = randi([1, length(chromosome)]);
        point2 = randi([1, length(chromosome)]);
    end 
    flip = randpom(chromosome(point1:point2));
    chromosome(point1:point2) = flip;
    scrambleChromosome =chromosome;
end
function inverseChromosome = InversionMutation(chromosome)
    point1 = randi([1, length(chromosome)]);
    point2 = randi([1, length(chromosome)]);
    while(point1>=point2)
        point1 = randi([1, length(chromosome)]);
        point2 = randi([1, length(chromosome)]);
    end 
    flip = fliplr(chromosome(point1:point2));
    chromosome(point1:point2) = flip;
    inverseChromosome =chromosome;
end
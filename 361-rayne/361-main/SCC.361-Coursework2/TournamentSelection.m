% Tournament Selection Selection.Using fitness in each group of choise to
% compare the better one. Replace the group with better fitness
% ---------------------------------------------------------
function choice = TournamentSelection(fitness)
chr1 = randi([1 length(fitness)]);
chr2 = randi([1 length(fitness)]);
if(fitness(chr1)> fitness(chr2))
    choice =chr1;
else
    choice = chr2;
end
end
 
 
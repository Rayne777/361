% computes distance of travel from each city to the next coming back to the
% first city in a circle
%   using euclidian distance
% chromosome is a 1 x 100 dimensional vector that lists all cities in the
% order they should be visited
function distance = computeRoundTripDistance(chromosome, distMat)
    dist = 0;
    for i = 1:1:length(chromosome)
        if(i ~= length(chromosome))
            dist = dist+distMat(chromosome(1, i), chromosome(1, (i+1)));
        else %distance from last city back to first city
            dist = dist+distMat(chromosome(1, i), chromosome(1, 1));
        end
    end
    distance = dist;
end


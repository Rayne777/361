clear;
close all;
iter = 10000;% Number of iterations: repeat "iter" times 
population_size = 20; % Number of chromosomes in population
prompt = "Do you want to use defalut algorthim ,plz enter1 ""or you want to choose the algorthims, plz enter2 ";
choice = input(prompt);
if choice ==1
    prompt_info="The default algorthim will be RouletteWheel(Selection)";

    x1=1;
    x2=1;
    x3=1;
else
    prompt1 = "Please enter which selection algorithm you would like:1.Tournament Selection;2.Truncation Selection;3.RouletteWheel Selection ";
    x1 = input(prompt1);
    prompt2 = "Please enter which Crossover algorithm you would like:1.Single Point Crossover;2.Two-Point Crossover ;3.Uniform Crossover ";
    x2 = input(prompt2);
    prompt3 = "Please enter which Mutation algorithm you would like:1.Inversion Mutation;2.Swap Mutation;3.Scramble Mutation ";
    x3 = input(prompt3);
end
tic;
%% generate random population of "population_size" chromosomes
population = zeros(population_size,30);
for i = 1:population_size
    index = 0:9;
    temp_chromosome((index*3)+1) = randi([1,4]);
    temp_chromosome((index*3)+2) = randi([0,9]);
    temp_chromosome((index*3)+3) = randi([0,9]);
    population(i,:) = temp_chromosome;
end
%% always have an extra column at end
population = [population zeros(population_size,1)];
fitness_data =zeros(iter,1);
file = dlmread('muir_world.txt',' ');
%%repeat iter times; each time generates a new population
for k = 1:iter
    %% evaluate fitness scores
    for i = 1:population_size
        [fitness, trail] = simulate_ant(file, population(i,:)); 
        population(i,31)=fitness;
    end  
    
    %% elite, keep best 2
    population = sortrows(population,31);
    population_new = zeros(population_size,30);
    population_new(1:2,:) = population(population_size-1:population_size,1:30);
    population_new_num = 2;
    fitness_data(k,1)=population(population_size,31);
    
    while(population_new_num < population_size)  
        if x1 == 1
            %% repeat until new population is full
            %% use a selection method and pick two chromosomes
            %TournamentSelection algorithm
                choice1 = TournamentSelection(population(:,31));
                choice2 = TournamentSelection(population(:,31));
                temp_chromosome_1 = population(choice1, 1:30);
                temp_chromosome_2 = population(choice2, 1:30);
        elseif x1 == 2
             %TruncationSelection algorithm
                temp_chromosome_1 = population_new(1, 1:30);
                temp_chromosome_2 = population_new(2, 1:30);

        else
                weights= population(:,31)/sum(population(:,31));
                choice1 = RouletteWheelSelection(weights);
                choice2 = RouletteWheelSelection(weights);
                temp_chromosome_1 = population(choice1, 1:30);
                temp_chromosome_2 = population(choice2, 1:30); 
        end
        %% crossover prob 0.8 and random pick cross point
        if(rand<0.8)
            if x2 == 1 
               %%Single-Point Crossover Operator
                temp_i = randi([1,29]);
                temp_chr = [temp_chromosome_1(1:temp_i) temp_chromosome_2(temp_i+1:end)];
                temp_chromosome_2 = [temp_chromosome_2(1:temp_i) temp_chromosome_1(temp_i+1:end)];
                temp_chromosome_1 = temp_chr;
               %%Two-Point Crossover Operator
            elseif x2==2
                firstOverPoint = randi([1,29]);
                secondOverPoint = randi([1,29]);
                size1 =size(firstOverPoint);
                size2 = size(secondOverPoint);
                %Make sure firstOverPoint <secondOverPoint
                while firstOverPoint>=secondOverPoint
                    firstOverPoint = randi([1,29]);
                    secondOverPoint = randi([1,29]);
                end
                tmp = firstOverPoint;
                firstOverPoint =secondOverPoint;
                secondOverPoint = tmp;
                
            else       
                %%%Uniform Crossover Operator
                p=0.5;
                temp_i = randi([1,29]);
                temp_chr = [temp_chromosome_1(1:temp_i) temp_chromosome_2(temp_i+1:end)];
                for i = 1:temp_i
                    if temp_chr(i) < p
                        temp = temp_chromosome_1;
                        temp_chromosome_1 = temp_chromosome_2;
                        temp_chromosome_2 = temp;
                    end
                end
                
            end

            %% mutation prob 0.2 and random pick bit to switch
            if (rand < 0.2)
                
                if x3==1
                    index=0:9;
                    while (any(temp_chromosome_2(index*3+1)>4) ||(temp_chromosome_2(index*3+1)<1))
                    temp_chromosome_1 = InversionMutation(temp_chromosome_1);
                    temp_chromosome_2 = InversionMutation(temp_chromosome_1);
                    end

                elseif x3==2
                    index=0:9;
                    while(any(temp_chromosome_2(index*3+1)>4) ||(temp_chromosome_2(index*3+1)<1))                   
                        temp_chromosome_1 = SwapMutation(temp_chromosome_1);
                    temp_chromosome_2 = SwapMutation(temp_chromosome_1);
                    end
                else
                    index=0:9;
                    while(any(temp_chromosome_2(index*3+1)>4) ||(temp_chromosome_2(index*3+1)<1))                    
                        temp_chromosome_1 = ScrambleMutation(temp_chromosome_1);
                    temp_chromosome_2 = ScrambleMutation(temp_chromosome_1);
                    end
                end
            end

            %% put in new population, add first new chromosome
                population_new_num = population_new_num + 1;
                population_new(population_new_num,:) = temp_chromosome_1;
                population_new(population_new_num,:) = temp_chromosome_2;
   
        end
    end
    
    
    %% replace, last column not updated yet
    population(:,1:30) = population_new;
end

%% at end: evaluate fitness scores and rank them
population = sortrows(population,31);
population(end,31);

minDist = 1/(population(end,31)); %minimum distance in last generation
optRoute = (population(end, 1:30));%route of best candidate in last generation 1x100 matrix
[fitnessAscSortValue,fitnessAscSortIndex] = sort(fitness,'descend');
best_fitness = fitnessAscSortValue(1);
toc;
hf = figure(1); set(hf,'Color',[1 1 1]);
hp = plot(1:iter,100*fitness_data/89,'r');
set(hp,'LineWidth',2);
axis([0 iter 0 100]); grid on;
xlabel('Generation number');
ylabel('Ant fitness [%]');
title('Ant fitness as a function of generation');
% read the John Moir Trail (world)
filename_world = 'muir_world.txt';
world_grid = dlmread(filename_world,' ');
% display the John Moir Trail (world)
world_grid = rot90(rot90(rot90(world_grid)));
xmax = size(world_grid,2);
ymax = size(world_grid,1);
hf = figure(2); set(hf,'Color',[1 1 1]);
for y=1:ymax
    for x=1:xmax
        if(world_grid(x,y) == 1)
        h1 = plot(x,y,'sk');
        hold on
        end
    end
end
grid on
% display the fittest Individual trail
for k=1:size(trail,1)
h2 = plot(trail(k,2),33-trail(k,1),'*m');
hold on
end
axis([1 32 1 32])
title_str = sprintf('John Muri Trail - Hero Ant fitness %d%% in %d generation ',uint8(100*best_fitness/89), iter);
title(title_str)
lh = legend([h1 h2],'Food cell','Ant movement');
set(lh,'Location','SouthEast');
% MATLAB Script: Traffic and Charging Infrastructure Simulation

clc; clear; close all;

%% Parameters
numEVs = 20;                   % Number of electric vehicles
numStations = 5;               % Number of charging stations
citySize = 10;                 % Size of the city grid (10x10 blocks)
timeSteps = 100;               % Simulation time steps
chargingRange = 3;             % Range of grid interaction for charging stations

% Random seed for reproducibility
rng(1);

% Define positions of charging stations
stations = randi(citySize, numStations, 2);

% Initialize EVs with random positions and destinations
EVs = struct();
for i = 1:numEVs
    EVs(i).pos = randi(citySize, 1, 2);        % Initial position [x, y]
    EVs(i).dest = randi(citySize, 1, 2);       % Destination [x, y]
    EVs(i).battery = randi([50, 100]);         % Battery percentage
end

% Grid connections
gridConnection = linspace(0, 1, numStations);  % Example power supply to stations

%% Visualization Setup
figure('Name', 'Traffic and Charging Infrastructure Simulation', ...
    'Color', 'w', 'Position', [100, 100, 1000, 800]);

hold on;
axis([0, citySize, 0, citySize]);
grid on;
xlabel('X (City Blocks)');
ylabel('Y (City Blocks)');
title('Traffic and Charging Infrastructure Simulation');

% Plot charging stations
scatter(stations(:,1), stations(:,2), 100, 'r', 'filled', ...
    'DisplayName', 'Charging Stations');
legend('Location', 'northeastoutside');

% Draw grid connections
for i = 1:numStations
    line([stations(i,1), stations(i,1)], [stations(i,2), citySize + 2], ...
        'Color', [0, 0.5, 1], 'LineWidth', 1.5, ...
        'DisplayName', 'Grid Connection');
end

% Annotate charging station power supply
for i = 1:numStations
    text(stations(i,1), stations(i,2) + 0.5, ...
        sprintf('Power: %.1f', gridConnection(i)), ...
        'FontSize', 10, 'Color', 'b', 'HorizontalAlignment', 'center');
end

%% Simulation Loop
for t = 1:timeSteps
    % Clear previous EV positions
    EVplots = findobj(gca, 'Tag', 'EV');
    delete(EVplots);
    
    % Update EV positions
    for i = 1:numEVs
        % Move EVs toward their destinations
        moveDir = sign(EVs(i).dest - EVs(i).pos);  % Move direction
        EVs(i).pos = EVs(i).pos + moveDir;        % Update position
        
        % Check if EV has reached the destination
        if isequal(EVs(i).pos, EVs(i).dest)
            EVs(i).dest = randi(citySize, 1, 2);  % Assign new destination
        end
        
        % Battery drain
        EVs(i).battery = max(0, EVs(i).battery - 1); % Decrease battery
        
        % Check for charging at nearby station
        for s = 1:numStations
            if norm(EVs(i).pos - stations(s,:)) <= chargingRange && EVs(i).battery < 80
                EVs(i).battery = min(100, EVs(i).battery + 10); % Charge battery
            end
        end
        
        % Plot EV position
        scatter(EVs(i).pos(1), EVs(i).pos(2), 50, 'g', 'filled', ...
            'Tag', 'EV', 'DisplayName', 'EV');
    end
    
    % Pause for visualization
    pause(0.1);
end

% Finalize Plot
legend('Charging Stations', 'Grid Connection', 'EVs', ...
    'Location', 'northeastoutside');

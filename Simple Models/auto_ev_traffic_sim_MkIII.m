% EV Traffic Simulation using Automated Driving Toolbox

% --- Simulation Parameters ---
numVehicles = 5;
totalTime = 60;
dt = 0.1;
numSteps = totalTime / dt;
chargeRate = 2;
lowChargeThreshold = 20;

% --- Define Road Network ---
% Create a rectangular road network using driving.scenario
scenario = drivingScenario('SampleTime', dt);
roadCenters = [0 0; 50 0; 100 50; 50 100; 0 50; -50 50; 0 0];
roadWidth = 3.6; % Standard road width in meters
road = road(scenario, roadCenters, roadWidth);

% Create charging station
chargingStationPos = [0 0 0];

% --- Initialize Vehicles ---
% Create vehicle array using the automated driving toolbox
vehicles = cell(1, numVehicles);
SOC = 50 * ones(1, numVehicles);
vehicleLength = 4.7;
vehicleWidth = 1.8;
vehicleHeight = 1.4;

% Different starting positions along the track
startPositions = {...
    [0 0 0], ...
    [10 0 0], ...
    [20 0 0], ...
    [30 0 0], ...
    [40 0 0]...
};

% Initialize vehicles with automated driving toolbox
for i = 1:numVehicles
    vehicles{i} = vehicle(scenario, ...
        'Position', startPositions{i}, ...
        'Length', vehicleLength, ...
        'Width', vehicleWidth, ...
        'Height', vehicleHeight);
end

% Create chase plots for visualization
chasePlots = cell(1, numVehicles);
for i = 1:numVehicles
    chasePlots{i} = chassisViewer(vehicles{i}, 'Chassis', true);
end

% Create bird's eye plot
bep = birdsEyePlot(scenario);
hold on;

% Add charging station marker
plot3(chargingStationPos(1), chargingStationPos(2), chargingStationPos(3), ...
    'r*', 'MarkerSize', 10, 'LineWidth', 2);
text(chargingStationPos(1)+5, chargingStationPos(2)+5, '⚡ Charging Station', ...
    'FontSize', 10);

% Create waypoints for each vehicle
waypoints = cell(1, numVehicles);
for i = 1:numVehicles
    % Create offset waypoints for each vehicle to avoid collisions
    offset = (i-1) * 2; % Meters offset from center
    waypoints{i} = roadCenters + [cos(pi/2)*offset sin(pi/2)*offset zeros(size(roadCenters,1),1)];
end

% --- Path Following Controllers ---
controllers = cell(1, numVehicles);
for i = 1:numVehicles
    controllers{i} = lateralControllerStanley(vehicles{i});
    controllers{i}.Waypoints = waypoints{i};
end

% --- Simulation Loop ---
while advance(scenario)
    % Get current time
    t = scenario.SimulationTime;
    
    % Update each vehicle
    for v = 1:numVehicles
        % Get current position
        pos = vehicles{v}.Position;
        
        % Calculate distance to charging station
        distToCharger = norm(pos(1:2) - chargingStationPos(1:2));
        
        % Update SOC based on distance to charger
        if distToCharger < 10 % Near charging station
            SOC(v) = min(SOC(v) + chargeRate * dt, 100);
        else
            SOC(v) = max(SOC(v) - 0.1 * dt, 0);
        end
        
        % Update vehicle color based on SOC
        if SOC(v) < lowChargeThreshold
            vehicles{v}.Color = [1 0 0]; % Red for low charge
        else
            vehicles{v}.Color = [0 1 0]; % Green for normal charge
        end
        
        % Calculate steering and speed commands
        [steerCmd, speedCmd] = controllers{v}(pos);
        
        % Adjust speed based on SOC
        if SOC(v) < lowChargeThreshold
            speedCmd = speedCmd * 0.5; % Reduce speed when low on charge
        end
        
        % Move vehicle
        move(vehicles{v}, speedCmd, steerCmd);
    end
    
    % Display SOC information
    clc;
    fprintf('Time: %.1f s\n', t);
    for v = 1:numVehicles
        fprintf('Vehicle %d SOC: %.1f%%\n', v, SOC(v));
    end
    
    % Update visualization
    updatePlots(bep);
    for i = 1:numVehicles
        update(chasePlots{i});
    end
    
    drawnow;
end

% Helper function to check if vehicle has reached waypoint
function reached = hasReachedWaypoint(pos, waypoint, threshold)
    reached = norm(pos(1:2) - waypoint(1:2)) < threshold;
end
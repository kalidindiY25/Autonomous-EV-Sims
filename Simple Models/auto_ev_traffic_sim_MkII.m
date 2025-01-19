% --- Simulation Parameters ---
numVehicles = 5; % Number of EVs
trackPoints = [0 0; 50 0; 100 50; 50 100; 0 50; -50 50]; % Closed track (city block outline)
totalTime = 60; % Total simulation time in seconds
dt = 0.1; % Time step in seconds
numSteps = totalTime / dt; % Total simulation steps
chargeRate = 2; % Charge rate (% per second)
SOC = 50 * ones(1, numVehicles); % Initial SOC for all vehicles
lowChargeThreshold = 20; % Threshold to trigger "charging"

% --- Track Preparation ---
track = repmat(trackPoints, 1, 1); % Duplicate track for repeated movement
trackX = track(:,1); % X-coordinates of track
trackY = track(:,2); % Y-coordinates of track

% --- Initialize Vehicles ---
vehiclePositions = zeros(numVehicles, 2); % [x, y] positions
vehicleIndices = ones(1, numVehicles); % Track point index for each vehicle
vehicleSprites = ["🚗", "🚙", "🚕", "🚘", "🚓"]; % Car emojis for each vehicle

% --- Set Up Figure ---
figure;
hold on;
axis([-100 150 -100 150]);
set(gca, 'Color', [0.8, 0.9, 1]); % Light blue background for city block
title('2D EV Traffic Simulation');
xlabel('X (meters)');
ylabel('Y (meters)');

% Draw the city block and charging station
cityBlock = fill([-50 100 100 -50], [-50 -50 100 100], [0.9, 0.9, 0.9], 'EdgeColor', 'k'); % Gray block
text(0, 50, '🏙️ City Block', 'HorizontalAlignment', 'center', 'FontSize', 12);

chargingStation = plot(0, 0, 'r*', 'MarkerSize', 10, 'LineWidth', 2); % Charging station at the center
text(5, 5, '⚡ Charging Station', 'FontSize', 10);

% Initialize vehicle sprites
vehiclePlots = gobjects(1, numVehicles);
for i = 1:numVehicles
    vehiclePlots(i) = text(trackX(1), trackY(1), vehicleSprites(i), 'FontSize', 14, 'HorizontalAlignment', 'center');
end

% --- Simulation Loop ---
for t = 1:numSteps
    % Update vehicle positions and check SOC
    for v = 1:numVehicles
        % Move vehicles along the track
        vehicleIndices(v) = mod(vehicleIndices(v), size(track, 1)) + 1; % Loop around track
        vehiclePositions(v, :) = [trackX(vehicleIndices(v)), trackY(vehicleIndices(v))];

        % Update SOC (simulate charging at station)
        if norm(vehiclePositions(v, :) - [0, 0]) < 10 % Near charging station
            SOC(v) = min(SOC(v) + chargeRate * dt, 100); % Recharge
        else
            SOC(v) = max(SOC(v) - 0.1 * dt, 0); % Discharge
        end

        % Update vehicle sprite
        if SOC(v) < lowChargeThreshold
            vehicleSprites(v) = "⚠️"; % Low charge warning
        else
            vehicleSprites(v) = "🚗"; % Normal sprite
        end

        % Update position on the plot
        set(vehiclePlots(v), 'Position', [vehiclePositions(v, 1), vehiclePositions(v, 2)]);
        set(vehiclePlots(v), 'String', vehicleSprites(v));
    end

    % Display SOC for each vehicle
    disp(['Time: ', num2str(t * dt, '%.1f'), ' s']);
    for v = 1:numVehicles
        disp(['Vehicle ', num2str(v), ' SOC: ', num2str(SOC(v), '%.1f'), '%']);
    end

    % Pause to visualize simulation
    pause(dt);
end

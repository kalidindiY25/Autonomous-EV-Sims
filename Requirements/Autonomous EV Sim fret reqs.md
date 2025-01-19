# Requirements for Project `Autonomous EV Sim`
|ID|P-ID| Text | Rationale |
|---|---|---|---|
| REQ-05.02 | REQ-05 | Upon  pedestrian_detected  the  EV_navigation_system  shall  immediately  satisfy  stopping_action  | Ensures pedestrian safety at crossings.
| REQ-02.01 | REQ-02 |  If sensor_malfunction = ON  the  EV_diagnostics_system  shall  immediately  satisfy  failure_flag = ON  | Enables timely detection and repair of critical components.
| REQ-04 |  | The  EV_collision_avoidance_system  shall always satisfy  distance_to_obstacle >= SAFE_DISTANCE  | Prevents accidents by maintaining safe distances from other vehicles and obstacles.
| REQ-03.01 | REQ-03 | Upon  traffic_jam_detected = ON  the  EV_navigation_system  shall  immediately  satisfy  optimal_route_update  | Minimises delays by adapting to real-time traffic data.
| REQ-01.04 | REQ-01 | Upon  receipt_of_charging_request_command & grid_load = low  the  EV_energy_management_system  shall  always  satisfy  grid_load = low  | Reduces strain on grid during peak hours.
| REQ-01.02 | REQ-01 | The  EV_charging_system  shall always satisfy  battery_level <= 100/100  | Prevents overcharging and potential battery damage.
| REQ-02.02 | REQ-02 |  EV_diagnostics_system  shall always satisfy  failure_log_format  | Ensures proper tracking and resolution of communication errors.
| REQ-05.03 | REQ-05 | Upon ( traffic_light_state = YELLOW  &  distance_to_light < 20 )  EV_navigation_system  shall at the next timepoint satisfy  stopping_action = ON  | Safely handles transitional traffic light states.
| REQ-04.01 | REQ-04 | The  EV_collision_avoidance_system  shall always satisfy  distance_to_vehicle_ahead >= 10  | Reduces risk pf rear-end collisions.
| REQ-02 |  |  EV_diagnostics_system  shall always satisfy  standard_diagnostic_reporting_format  | Ensures consistent reporting for effective issue tracking and maintenance.
| REQ-03.02 | REQ-03 |  EV_navigation_system  shall always satisfy if preBool(false,  battery_level < 20/100  & !(  charging_station_nearby )) then  continue_search_for_station = ON  | Prevents vehicles from running out of charge in transit.
| REQ-01.01 | REQ-01 |  EV_energy_management_system  shall always satisfy if ( EV_state = moving  &  battery_level < 20 ) then  low_power_mode = ON  | Minimise non-critical EV operations to prolong battery life.
| REQ-05 |  |  EV_navigation_system  shall always satisfy if ( traffiic_rules = ACTIVE  &  road_conditions = NORMAL ) then  traffic_compliance = ON  | Ensures the EV adheres to traffic rules and operates safely within legal boundaries.
| REQ-05.01 | REQ-05 |  EV_navigation_system  shall always satisfy if ( traffic_light_state = RED  &  distance_to_light < 50 ) then  stopping_action = ON  | 
| REQ-05.04 | REQ-05 |  EV_navigation_system  shall always satisfy if ( emergency_vehicle_detected = ON  &  distance_to_emergency_vehicle < 20 ) then  stopping_action = ON  | Ensures compliance with traffic laws requiring vehicles to yield to emergency responders.
| REQ-03 |  | Upon ( traffic_conditions = CONGESTED  &  EV_routing_request = ON )  EV_navigation_system  shall at the next timepoint satisfy  updated_route = OPTIMAL  | Dynamically adjusts routing to reduce delays and improve overall efficiency.
| REQ-01.03 | REQ-01 |  If grid_demand_peak = YES  the  EV_energy_management_system  shall  within 5 seconds  satisfy  EV_discharge_mode = ON  | Stabilises grid during peak electricity demand using EVs as distributed storage units.
| REQ-01 |  |  If energy_efficiency_mode = ON  the  EV_energy_management_system  shall  immediately  satisfy  optimal_battery_usage = ON  | Enables efficient battery management to prolong operational time and support grid stabilisation.

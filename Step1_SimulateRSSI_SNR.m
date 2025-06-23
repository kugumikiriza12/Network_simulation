% Step 1: Simulate RSSI and SNR for 5 wireless nodes over 24 hours 

% 1.1 Simulation time settings
duration_minutes = 1440;            % Total time: 24 hours
time_step = 10;                     % 10-minute intervals
t = (0:time_step:duration_minutes - time_step)';  % 144 time points
n = length(t);                      % Number of time samples

% 1.2 Define number of users and their distances from AP
N = 5;                              % Number of wireless users
distances = randi([50, 500], N, 1); % Random distance per user (50–500 m)

% 1.3 Initialize matrices
RSSI = zeros(n, N);
SNR = zeros(n, N);

% 1.4 Simulation Parameters
P_tx = 15;             % transmit power
n_path = 3.5;          % path loss exponent for steeper signal drop-off
sigma_fading = 2;      % Shadow fading standard deviation for RSSI

for i = 1:N
    d = distances(i);
    fading = randn(n, 1) * sigma_fading;
    RSSI(:, i) = P_tx - 10 * n_path * log10(d) + fading;  % RSSI model

    % SNR model 
    SNR(:, i) = 18 + 7 * cos(2 * pi * t / 360) + randn(n, 1) * 3.5;
end

% 1.5 Clamp values to realistic wireless operating ranges
RSSI = max(min(RSSI, -30), -100);
SNR = max(min(SNR, 40), 0);

% 1.6 Assemble all data into a single table
T = table();
for i = 1:N
    temp = table(t, t/60, ...
        repmat(i, n, 1), ...
        repmat(distances(i), n, 1), ...
        RSSI(:, i), SNR(:, i), ...
        'VariableNames', {'Time_min', 'Time_hr', 'User_ID', 'Distance_m', 'RSSI_dBm', 'SNR_dB'});
    T = [T; temp];
end

% 1.7 Save the updated dataset to CSV
writetable(T,'Simulated_WirelessMetrics_Step1.csv');

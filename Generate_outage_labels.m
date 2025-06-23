% generate_outage_labels.m
% Step 2: Label outages based on RSSI < -75 dBm or SNR < 10 dB

% Read the simulated signal dataset from Step 1
data = readtable('Simulated_WirelessMetrics_Step1.csv');

% Extract signal metrics and time
RSSI = data.RSSI_dBm;
SNR  = data.SNR_dB;
timestamps = data.Time_min;

% Define thresholds
rssiThreshold = -75;  %  rssi threshold 
snrThreshold  = 10;   % Standard SNR threshold

% Label outage: 1 if RSSI or SNR below threshold, else 0
outageLabels = (RSSI < rssiThreshold) | (SNR < snrThreshold);
data.Outage = double(outageLabels);  % Convert logical to numeric

% Save labeled dataset
writetable(data, 'LabeledWirelessData_Step2.csv');
% rng(21);  % Lock random generator
% Plot outage timeline using stairs to avoid diagonal X artifacts
figure;
stairs(timestamps, data.Outage, 'r', 'LineWidth', 1.5);
ylim([-0.2 1.2]);
yticks([0 1]);
yticklabels({'No Outage', 'Outage'});
xlabel('Time (minutes)');
ylabel('Outage Label');
title('Outage Detection Based on RSSI < -75 dBm or SNR < 10 dB');
grid on;
saveas(gcf, 'outage_detection_plot.jpg');

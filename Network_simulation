% Step 4: Train DT and generate clean confusion matrix for outage prediction
% Load labeled dataset
data = readtable('LabeledWirelessData_Step2.csv');

% Extract features and target
X = [data.RSSI_dBm, data.SNR_dB];
Y = data.Outage;

% Split data (70% train / 30% test)
cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv), :);
YTrain = Y(training(cv));
XTest = X(test(cv), :);
YTest = Y(test(cv));

% Train DT model
% SVMModel = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');

% Predict on test set
YPred = predict(SVMModel, XTest);

% Generate confusion matrix only
figure;
cm = confusionchart(YTest, YPred, ...
    'Title', 'DT Confusion Matrix (Outage Prediction)', ...
    'RowSummary', 'row-normalized', ...
    'ColumnSummary', 'off');
cm.FontName = 'Arial';
cm.FontSize = 12;
cm.DiagonalColor = [0 0.6 0];    % Green for correct
cm.OffDiagonalColor = [0.85 0 0]; % Red for errors

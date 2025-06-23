% Train k-NN  and generate clean confusion matrix for outage prediction

% Load dataset
data = readtable('LabeledWirelessData_Step2.csv');

% Extract and normalize features
X = normalize([data.RSSI_dBm, data.SNR_dB]);
Y = data.Outage;

% Split data (70% train / 30% test)
cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv), :);
YTrain = Y(training(cv));
XTest = X(test(cv), :);
YTest = Y(test(cv));

% Train k-NN model with k = 4
KNNModel = fitcknn(XTrain, YTrain, ...
    'NumNeighbors', 4, ...
    'Distance', 'euclidean');  

% Predict on test set 
YPred = predict(KNNModel, XTest);

% Confusion matrix
% figure;
% cm = confusionchart(YTest, YPred, ...
%     'Title', 'k-NN Confusion Matrix (Outage Prediction)', ...
%     'RowSummary', 'row-normalized', ...
%     'ColumnSummary', 'off');
% cm.FontName = 'Arial';
% cm.FontSize = 12;
% cm.DiagonalColor = [0 0.6 0];
% cm.OffDiagonalColor = [0.85 0 0];

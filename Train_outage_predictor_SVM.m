% Step 3: Train SVM and generate clean confusion matrix for outage prediction
% 1️⃣ Load the labeled dataset (Step 2 output with RSSI < -75 dBm or SNR < 10 dB)
data = readtable('LabeledWirelessData_Step2.csv');

% 2️⃣ Extract features and target
X = [data.RSSI_dBm, data.SNR_dB];
Y = data.Outage;

% 3️⃣ Check class distribution
disp('Class distribution in full dataset:');
tabulate(Y);
% rng(13);  % Lock random generator
% 4️⃣ Split data (70% train / 30% test)
cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv), :);
YTrain = Y(training(cv));
XTest = X(test(cv), :);
YTest = Y(test(cv));

disp('Class distribution in test set:');
tabulate(YTest);

% 5️⃣ Train SVM model
SVMModel = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear');

% 6️⃣ Predict on test set
[YPred, scores] = predict(SVMModel, XTest);

% 7️⃣ Evaluate performance
accuracy = sum(YPred == YTest) / length(YTest);
precision = sum((YPred == 1) & (YTest == 1)) / max(sum(YPred == 1), 1);
recall = sum((YPred == 1) & (YTest == 1)) / max(sum(YTest == 1), 1);
F1 = 2 * (precision * recall) / max((precision + recall), 1);

fprintf('\nModel Performance:\n');
fprintf('Accuracy: %.2f%%\n', accuracy * 100);
fprintf('Precision: %.2f%%\n', precision * 100);
fprintf('Recall: %.2f%%\n', recall * 100);
fprintf('F1 Score: %.2f%%\n', F1 * 100);

% 8️⃣ Generate clean confusion matrix
figure;
cm = confusionchart(YTest, YPred, ...
    'Title', 'SVM Confusion Matrix (Outage Prediction)', ...
    'RowSummary', 'row-normalized', ...
    'ColumnSummary', 'off');
cm.FontName = 'Arial';
cm.FontSize = 12;
cm.DiagonalColor = [0 0.6 0];    % Green for correct
cm.OffDiagonalColor = [0.85 0 0]; % Red for errors
% Precision-Recall Curve
YTestLogical = logical(YTest);
[prec, rec, ~, prAUC] = perfcurve(YTestLogical, scores(:,2), true, ...
                                  'xCrit', 'reca', 'yCrit', 'prec');

figure;
plot(rec, prec, 'b-', 'LineWidth', 2);
xlabel('Recall');
ylabel('Precision');
title(sprintf('Precision-Recall Curve (AUC = %.2f)', prAUC));
grid on;
% Decision Boundary Plot
xMin = min(XTest(:,1)) - 1; xMax = max(XTest(:,1)) + 1;
yMin = min(XTest(:,2)) - 1; yMax = max(XTest(:,2)) + 1;
[x1Grid, x2Grid] = meshgrid(linspace(xMin, xMax, 100), linspace(yMin, yMax, 100));
XGrid = [x1Grid(:), x2Grid(:)];
[~, gridScores] = predict(SVMModel, XGrid);

figure;
gscatter(XTest(:,1), XTest(:,2), YTest, 'bg', 'ox');
hold on;
contour(x1Grid, x2Grid, reshape(gridScores(:,2), size(x1Grid)), [0 0], 'k', 'LineWidth', 2);
xlabel('RSSI (dBm)');
ylabel('SNR (dB)');
title('SVM Decision Boundary for Outage Classification');
legend('No Outage', 'Outage', 'Decision Boundary');
grid on;
saveas(gcf, 'SVM Decision Boundary for Outage Classification');


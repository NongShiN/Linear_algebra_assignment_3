function data = dataloader(file1, file2)
    % read csv (sep=',')
    data1 = readtable(file1, 'Delimiter', ',', 'VariableNamingRule', 'preserve');
    data2 = readtable(file2, 'Delimiter', ',', 'VariableNamingRule', 'preserve');
    
    % concat data1 and data2
    data = vertcat(data1, data2);

    % Check some of table
    disp(head(data));
end

function [a, b] = linearRegression(X, Y)
    %{ 
    linearRegression calculates the slope (a) and intercept (b) for 
    a simple linear regression line Y = a*X + b using the least squares method.
    
    Inputs:
       X - A vector or column matrix containing the independent variable values.
       Y - A vector or column matrix containing the dependent variable values.
    
    Outputs:
       a - The slope of the regression line.
       b - The intercept of the regression line.
    %}

    % transform variables to vector
    X = X(:);
    Y = Y(:);
    
    % Calculate a (slope) and b (intercept) from input data
    n = length(X);
    sumX = sum(X);
    sumY = sum(Y);
    sumXY = sum(X .* Y);
    sumX2 = sum(X .^ 2);
    
    % Calculated by least squares method
    a = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX^2);
    b = (sumY - a * sumX) / n;
end

% Load data
data = dataloader('발전기 데이터 1.csv', '발전기 데이터 2.csv');

% Extracting column data
total_kWh = data{:, '전체합(kWh)'};
variables = data{:, {'경사', '수평', '모듈(℃)', '외기(℃)'}};

% Visualize
figure;
for i = 1:size(variables, 2)
    X = variables(:, i); % independent variable (경사, 수평, 모듈, 외기)
    Y = total_kWh; % dependent variable
    
    % Calculate linear regression
    [a, b] = linearRegression(X, Y);
    Y_pred = a * X + b; % predict
    
    % Calculate error
    SAE = sum(abs(Y - Y_pred)); % Sum of Absolute Errors
    SSE = sum((Y - Y_pred).^2); % Sum of Squared Errors
    
    % Ploting
    subplot(2, 2, i);
    scatter(X, Y, 'b', 'filled');
    hold on;
    plot(X, Y_pred, 'r', 'LineWidth', 2); % regression line
    title(sprintf('%s와 전체합(kWh) 관계', variable_names{i}));
    xlabel(variable_names{i});
    ylabel('전체합(kWh)');
    legend('데이터', '회귀선', 'Location', 'Best');
    grid on;
    
    % Print result
    fprintf('%s:\n', variable_names{i});
    fprintf('회귀식: Y = %.2fX + %.2f\n', a, b);
    fprintf('Sum of Absolute Errors (SAE): %.2f\n', SAE);
    fprintf('Sum of Squared Errors (SSE): %.2f\n\n', SSE);
end
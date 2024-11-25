function data = dataloader(file1, file2)
    % read csv (sep=',')
    data1 = readtable(file1, 'Delimiter', ',', 'VariableNamingRule', 'preserve');
    data2 = readtable(file2, 'Delimiter', ',', 'VariableNamingRule', 'preserve');
    
    % concat data1 and data2
    data = vertcat(data1, data2);

    % Check some of table
    disp(head(data));
end

% Load data
data = dataloader('발전기 데이터 1.csv', '발전기 데이터 2.csv');

% Extracting column data
% '전체합(kWh)'과 '경사' 변수 추출
Y = data{:, '전체합(kWh)'}; % 종속 변수 (전체합)
X = data{:, '경사'}; % 독립 변수 (경사)


% CVX를 이용한 선형 회귀 문제 설정
cvx_begin
    variables a b
    minimize(sum((Y - (a*X + b)).^2)) % 잔차 제곱의 합을 최소화
cvx_end

% 결과 출력
disp(['계수 a: ', num2str(a)]);
disp(['절편 b: ', num2str(b)]);

% 회귀 직선 시각화
figure;
scatter(X, Y, 'r', 'filled'); % 원본 데이터 시각화
hold on;
plot(X, a*X + b, 'b-', 'LineWidth', 2); % 회귀 직선 시각화
xlabel('경사');
ylabel('전체합(kWh)');
title('경사와 전체합(kWh) 사이의 선형 회귀');
legend('데이터', '회귀 직선');

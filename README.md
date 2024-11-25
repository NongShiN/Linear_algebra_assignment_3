# Linear Algebra Assignment Use Matlab

## Data Overview
### Preview
[사진1]
- Generator observation data from 2019.02.01 to 2019.03.31

### Data types
 feature | type |
------------|---------------|
일자           | object |
전체합(kWh)     | float64 |
경사  | float64 |
수평     | float64 |
모듈(℃)     | float64 |
외기(℃)        | float64 |


## Problem 1
### Analyze the linear regression relationship between the total sum and each variable (slope, horizontal, module, outside air)
#### 1.1. UDF linear regression
```matlab
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
```

#### 1.2. Errors
```matlab
% Y : True value
% Y_pred: predict value
SAE = sum(abs(Y - Y_pred)); % Sum of Absolute Errors
SSE = sum((Y - Y_pred).^2); % Sum of Squared Errors
```
- SAE Sum of Absolute Errors)
  
  The absolute value of the error between the predicted value and the actual value added together. The smaller the value, the more fit the model to the data.
- SSE Sum of Squared Errors)
  
  The sum of the squared errors between predicted and actual values. The smaller the value, the more fit the model to the data.

#### 1.3. Analysis Result
| | slope | horizontal | module | outside air |
------------|---------------|---------------|---------------|---------------|
Regression Equation           | Y = 0.05X-0.27 | Y = 0.04X-0.15 | Y = 0.88X+3.77 | Y = 0.84X+0.96 |
SAE     | 1297.52 | 888.92 | 8476.55 | 5195.30 |
SSE     | 8381.48 | 6713.46 | 111992.53 | 46172.69 |

- Variables with the highest fit: Horizontal

  Both SAE and SSE are the smallest.

- Variables with the lowest fit: Modules
  Both SAE and SSE are the largest.

- Looking at the regression coefficient, the module and the outside air have great influence, but this variable tend not to be able to explains the dependent variable well.

- There are some data that appear to be outliers when floating the data. When remove this data, this will improve the model performance.
  
- The performance of the model should be interpreted by considering SAE and SSE together, with additional coefficients of determination (R²). It seems that the evaluation can be supplemented with indicators such as AIC.

#### 1.4. Plotting
[사진2]


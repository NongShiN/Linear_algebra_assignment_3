# Linear Algebra Assignment Use Matlab

## Data Overview
### Preview

![사진1](https://github.com/user-attachments/assets/36c449f9-563d-44e0-a85c-de1b2055dd0b)

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


<img src="https://github.com/user-attachments/assets/08799083-0147-484b-9e10-d34f1fea40ec" alt="6" width="600"/>


### What linear regression problem can the relationship between '요금' and other variables be interpreted as?
#### 2.1. Multiple Linear Regression
- Multiple linear regression should be used to analyze the relationship between bill and slope, horizontal, module (℃), and outside air (℃) in a given problem.
- This is because several independent variables are likely to affect rates.

#### 2.2. Basis
- **Multiple independent variables**: Several variables such as slope, horizontal, module (℃), and outside air (℃) can affect the rate. Therefore, the influence of each variable should be considered simultaneously by applying multiple linear regression.
 
- **Linear relationship**: The basic assumption of regression analysis is when the relationship between variables is linear. That is, a multiple linear regression model is used assuming that each independent variable has a linear effect on the rate.

#### 2.3. Example of Multi Linear Regression
  We can express Bill(Y) predict model  like that:
  
     Y = β0 + β1 ∗ 경사 + β2 ∗ 수평 + β3 ∗ 모듈(℃) + β4 ∗ 외기(℃) + ϵ

Here,

   ㅤㅤㅤY : Bill
  
   ㅤㅤㅤβ0 : intercept
  
   ㅤㅤㅤβ1, β2, β3, β4 : regression coefficients for each independent variable
  
   ㅤㅤㅤϵ : error term

## Problem 2
### Use cvx library to derive coefficients when linear regression is used between '전체합' and '경사'
- How to use
```matlab
X_cvx = data{:, '경사'};
Y_cvx = total_kWh;
% Linear regression between '전체합' and '경사',
% the coefficient value is derived using cvx
cvx_begin
 variables a b
 minimize(sum((Y_cvx - (a * X_cvx + b)).^2))
cvx_end
```

![사진3](https://github.com/user-attachments/assets/521202c5-d2e3-49e5-a657-e3ba7f8ddf1e)

- Analysis Result

![사진4](https://github.com/user-attachments/assets/1fbf917a-63a0-46c1-bfd7-f6ad3386377d)

- Plotting

<img src="https://github.com/user-attachments/assets/39121146-444d-4c84-a4c1-697915e7ae53" alt="6" width="500"/>

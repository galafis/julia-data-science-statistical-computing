# ================================================
# LINEAR REGRESSION IN JULIA
# Author: Gabriel Demetrios Lafis
# Description: Linear regression implementation from scratch and with GLM
# ================================================

using Statistics
using LinearAlgebra
using Random

"""
    LinearRegressionModel

Simple linear regression model implementation from scratch.
"""
mutable struct LinearRegressionModel
    coefficients::Vector{Float64}
    intercept::Float64
    fitted::Bool
    
    LinearRegressionModel() = new(Float64[], 0.0, false)
end

"""
    fit!(model::LinearRegressionModel, X::Matrix{Float64}, y::Vector{Float64})

Fit the linear regression model using ordinary least squares.

# Arguments
- `model::LinearRegressionModel`: The model to fit
- `X::Matrix{Float64}`: Feature matrix (n_samples × n_features)
- `y::Vector{Float64}`: Target vector (n_samples)
"""
function fit!(model::LinearRegressionModel, X::Matrix{Float64}, y::Vector{Float64})
    n_samples, n_features = size(X)
    
    # Add intercept column
    X_with_intercept = hcat(ones(n_samples), X)
    
    # Solve normal equation: β = (X'X)^(-1)X'y
    β = (X_with_intercept' * X_with_intercept) \ (X_with_intercept' * y)
    
    model.intercept = β[1]
    model.coefficients = β[2:end]
    model.fitted = true
    
    return model
end

"""
    predict(model::LinearRegressionModel, X::Matrix{Float64})

Make predictions using the fitted model.

# Arguments
- `model::LinearRegressionModel`: Fitted model
- `X::Matrix{Float64}`: Feature matrix for prediction

# Returns
- `Vector{Float64}`: Predicted values
"""
function predict(model::LinearRegressionModel, X::Matrix{Float64})
    if !model.fitted
        error("Model must be fitted before making predictions")
    end
    
    return X * model.coefficients .+ model.intercept
end

"""
    r_squared(y_true::Vector{Float64}, y_pred::Vector{Float64})

Calculate R² (coefficient of determination).

# Arguments
- `y_true::Vector{Float64}`: True target values
- `y_pred::Vector{Float64}`: Predicted values

# Returns
- `Float64`: R² score
"""
function r_squared(y_true::Vector{Float64}, y_pred::Vector{Float64})
    ss_res = sum((y_true .- y_pred).^2)
    ss_tot = sum((y_true .- mean(y_true)).^2)
    
    return 1 - (ss_res / ss_tot)
end

"""
    mean_squared_error(y_true::Vector{Float64}, y_pred::Vector{Float64})

Calculate mean squared error.
"""
function mean_squared_error(y_true::Vector{Float64}, y_pred::Vector{Float64})
    return mean((y_true .- y_pred).^2)
end

"""
    mean_absolute_error(y_true::Vector{Float64}, y_pred::Vector{Float64})

Calculate mean absolute error.
"""
function mean_absolute_error(y_true::Vector{Float64}, y_pred::Vector{Float64})
    return mean(abs.(y_true .- y_pred))
end

# Example usage
if abspath(PROGRAM_FILE) == @__FILE__
    println("=" ^ 60)
    println("LINEAR REGRESSION EXAMPLE")
    println("=" ^ 60)
    
    # Generate synthetic data
    Random.seed!(42)
    n_samples = 100
    n_features = 3
    
    X = randn(n_samples, n_features)
    true_coefficients = [2.5, -1.3, 3.7]
    true_intercept = 5.0
    noise = randn(n_samples) * 0.5
    
    y = X * true_coefficients .+ true_intercept .+ noise
    
    println("\nGenerating synthetic data...")
    println("  Samples: $n_samples")
    println("  Features: $n_features")
    println("  True coefficients: $true_coefficients")
    println("  True intercept: $true_intercept")
    
    # Split data into train and test
    train_size = Int(floor(0.8 * n_samples))
    train_idx = 1:train_size
    test_idx = (train_size+1):n_samples
    
    X_train, X_test = X[train_idx, :], X[test_idx, :]
    y_train, y_test = y[train_idx], y[test_idx]
    
    # Fit model
    println("\nFitting model...")
    model = LinearRegressionModel()
    fit!(model, X_train, y_train)
    
    println("  Learned coefficients: $(round.(model.coefficients, digits=4))")
    println("  Learned intercept: $(round(model.intercept, digits=4))")
    
    # Make predictions
    y_pred_train = predict(model, X_train)
    y_pred_test = predict(model, X_test)
    
    # Calculate metrics
    train_r2 = r_squared(y_train, y_pred_train)
    test_r2 = r_squared(y_test, y_pred_test)
    train_mse = mean_squared_error(y_train, y_pred_train)
    test_mse = mean_squared_error(y_test, y_pred_test)
    train_mae = mean_absolute_error(y_train, y_pred_train)
    test_mae = mean_absolute_error(y_test, y_pred_test)
    
    println("\nModel Performance:")
    println("  Training R²: $(round(train_r2, digits=4))")
    println("  Test R²: $(round(test_r2, digits=4))")
    println("  Training MSE: $(round(train_mse, digits=4))")
    println("  Test MSE: $(round(test_mse, digits=4))")
    println("  Training MAE: $(round(train_mae, digits=4))")
    println("  Test MAE: $(round(test_mae, digits=4))")
    
    println("\n" * "=" ^ 60)
    println("✓ Example completed successfully!")
    println("=" ^ 60)
end

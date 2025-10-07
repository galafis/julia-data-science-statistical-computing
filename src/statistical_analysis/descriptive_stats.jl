# ================================================
# DESCRIPTIVE STATISTICS IN JULIA
# Author: Gabriel Demetrios Lafis
# Description: Statistical analysis functions using Julia
# ================================================

using Statistics
using StatsBase
using DataFrames
using CSV

"""
    calculate_descriptive_stats(data::Vector{<:Real})

Calculate comprehensive descriptive statistics for a numeric vector.

# Arguments
- `data::Vector{<:Real}`: A vector of numeric values

# Returns
- `Dict`: Dictionary containing various statistical measures
"""
function calculate_descriptive_stats(data::Vector{<:Real})
    stats = Dict(
        "mean" => mean(data),
        "median" => median(data),
        "mode" => mode(data),
        "std" => std(data),
        "var" => var(data),
        "min" => minimum(data),
        "max" => maximum(data),
        "range" => maximum(data) - minimum(data),
        "q1" => quantile(data, 0.25),
        "q3" => quantile(data, 0.75),
        "iqr" => quantile(data, 0.75) - quantile(data, 0.25),
        "skewness" => skewness(data),
        "kurtosis" => kurtosis(data),
        "count" => length(data)
    )
    
    return stats
end

"""
    print_stats_report(stats::Dict)

Print a formatted report of statistical measures.
"""
function print_stats_report(stats::Dict)
    println("=" ^ 50)
    println("DESCRIPTIVE STATISTICS REPORT")
    println("=" ^ 50)
    
    for (key, value) in sort(collect(stats))
        println("$(rpad(key, 20)): $(round(value, digits=4))")
    end
    
    println("=" ^ 50)
end

"""
    analyze_distribution(data::Vector{<:Real})

Analyze the distribution characteristics of the data.
"""
function analyze_distribution(data::Vector{<:Real})
    stats = calculate_descriptive_stats(data)
    
    # Determine if distribution is approximately normal
    skew = stats["skewness"]
    kurt = stats["kurtosis"]
    
    println("\nDistribution Analysis:")
    println("-" ^ 50)
    
    if abs(skew) < 0.5
        println("Skewness: Approximately symmetric")
    elseif skew > 0
        println("Skewness: Right-skewed (positive skew)")
    else
        println("Skewness: Left-skewed (negative skew)")
    end
    
    if abs(kurt) < 0.5
        println("Kurtosis: Approximately normal (mesokurtic)")
    elseif kurt > 0
        println("Kurtosis: Heavy-tailed (leptokurtic)")
    else
        println("Kurtosis: Light-tailed (platykurtic)")
    end
    
    # Outlier detection using IQR method
    q1 = stats["q1"]
    q3 = stats["q3"]
    iqr = stats["iqr"]
    
    lower_bound = q1 - 1.5 * iqr
    upper_bound = q3 + 1.5 * iqr
    
    outliers = filter(x -> x < lower_bound || x > upper_bound, data)
    
    println("\nOutlier Detection (IQR method):")
    println("Lower bound: $(round(lower_bound, digits=2))")
    println("Upper bound: $(round(upper_bound, digits=2))")
    println("Number of outliers: $(length(outliers))")
    println("Outlier percentage: $(round(length(outliers) / length(data) * 100, digits=2))%")
end

# Example usage
if abspath(PROGRAM_FILE) == @__FILE__
    # Generate sample data
    println("Generating sample data...")
    data = randn(1000) .* 10 .+ 50
    
    # Calculate and display statistics
    stats = calculate_descriptive_stats(data)
    print_stats_report(stats)
    
    # Analyze distribution
    analyze_distribution(data)
end

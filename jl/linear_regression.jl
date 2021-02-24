using LinearAlgebra

# Mykel J. Kochenderfer and Tim A. Wheeler, "Algorithms for Optimization", MIT Press, 2019.

function design_matrix(X)
    n, m = length(X[1]), length(X)
    return [j==0 ? 1.0 : X[i][j] for i in 1:m, j in 0:n]
end

function linear_regression(X, y)
    θ = pinv(design_matrix(X))*y
    return x -> θ⋅[1; x]
end

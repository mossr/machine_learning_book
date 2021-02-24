using LinearAlgebra

polynomial_bases_1d(i, k) = [x->x[i]^p for p in 0:k]
function polynomial_bases(n, k)
    bases = [polynomial_bases_1d(i, k) for i in 1:n]
    terms = Function[]
    for ks in Iterators.product([0:k for i in 1:n]...)
        if sum(ks) ≤ k
            push!(terms,  x->prod(b[j+1](x) for (j,b) in zip(ks,bases)))
        end
    end
    return terms
end


bases = [(x)->x^2 * log(x)]

function regression(X, y, bases)
    B = [b(x) for x in X, b in bases]
    θ = pinv(B)*y
    return x -> sum(θ[i] * bases[i](x) for i in 1:length(θ))
end


function plot_polynomial_regression(D, k=2)
    # Data
    X = map(first, D)
    y = map(last, D)

    bases = polynomial_bases(1, k) # 1D polynomial of degree k

    # Predictor
    h = regression(X, y, bases)

    p_data = Plots.Scatter(X, y, style="mark=x")
    xmin, xmax = 0, 7
    xn = xmin:0.1:xmax
    p_fit = Plots.Linear(xn, h.(xn), style="blue, no marks")

    x_th_string = "th"
    if k == 1
        x_th_string = "st"
    elseif k == 2
        x_th_string = "nd"
    elseif k == 3
        x_th_string = "rd"
    end
        
    return Axis([p_data, p_fit], xmin=xmin, xmax=xmax, ymin=0, ymax=4.5, title="\$$k\$-$x_th_string order polynomial", xlabel=L"x", ylabel=L"y")
end
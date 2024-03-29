### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 92728d70-69b5-11eb-2c45-33f34641f0a8
using PGFPlots

# ╔═╡ 62598390-69b6-11eb-19b7-119b6c33cf22
using DataFrames

# ╔═╡ 28d38fce-69b6-11eb-25ef-3d4496868f01
using CSV

# ╔═╡ f5f028a0-6a35-11eb-33fa-f3b07ad5b5c6
using LinearAlgebra

# ╔═╡ 41928830-9659-11eb-34ee-134854f44e89
using SymEngine

# ╔═╡ 73c2d230-69ca-11eb-0501-3f5888d0ba3a
include("gradient_descent.jl")

# ╔═╡ 60464710-69ce-11eb-269b-971338ea455e
include("linear_regression.jl")

# ╔═╡ ab94d1c0-6a35-11eb-2c69-8bd95ad0c0cd
include("locally_weighted_linear_regression.jl")

# ╔═╡ 0aa9b2f0-69b6-11eb-366a-e737fc6fb8fd
md"""
Data from: https://github.com/girishkuniyal/Predict-housing-prices-in-Portland/blob/master/ex1data2.txt
"""

# ╔═╡ e5cac3c0-69b5-11eb-215d-d726379edcdc
data = CSV.read("..\\data\\portland-houses.csv", DataFrame; header=["area", "bedrooms", "price"])

# ╔═╡ a7f4ba50-69b6-11eb-2dd1-53bffb85613a
X = data[:area]

# ╔═╡ af9f9e50-69b6-11eb-3f9a-f1bfe7d4e1d0
Y = data[:price] ./ 1000

# ╔═╡ a472b4f0-69b5-11eb-3374-65f8c9450019
PGFPlots.Axis(Plots.Scatter(X, Y, style="mark=x"), title="housing prices", xlabel="square feet", ylabel="price (in \\\$1000)", xmax=5000, ymax=800)

# ╔═╡ 64527d50-69ca-11eb-2df0-21c8ba5224b0
md"""
# Gradient Descent
"""

# ╔═╡ bdc49760-69ca-11eb-3590-d959c2e3007f
@vars x, y

# ╔═╡ 9bcdd400-69ca-11eb-35f4-53fc0ff06b7e
f = x^2/2 + y^2

# ╔═╡ 9a20c03e-69ca-11eb-3775-db0d1647ea9e
plot_gradient_descent(f, initial=[48, 30], path_length=40)

# ╔═╡ 5d9afd30-69ce-11eb-1332-b39a334600ad
md"""
# Linear Regression
"""

# ╔═╡ da30aff0-69d0-11eb-188e-ed08ff5a238b
h = linear_regression(X, Y)

# ╔═╡ eeb20410-69d0-11eb-3927-ff57dc94e7c9
h(0) # θ₀

# ╔═╡ dc4d7570-69d0-11eb-1d72-43ff72da44e5
h(1) - h(0) # θ₁

# ╔═╡ 658a8b50-69ce-11eb-0f31-2741a6b8f0c9
function example_linear_regression()
	# Predictor
	h = linear_regression(X, Y)

	p_data = Plots.Scatter(X, Y, style="mark=x")
	xn = (minimum(X) - 500):5000 # (maximum(X) + 500)

	p_fit = Plots.Linear(xn, h.(xn), style="blue, no marks")

	Axis([p_data, p_fit], title="housing prices", xlabel="square feet", ylabel="price (in \\\$1000)", xmin=first(xn), xmax=last(xn), ymax=800)
end

# ╔═╡ 82641a70-69ce-11eb-300b-3dbde391c20f
example_linear_regression()

# ╔═╡ 1cc27740-69d1-11eb-3988-bd4a299969e9
X2 = hcat(data[:area], data[:bedrooms])

# ╔═╡ 44d76420-69d1-11eb-0672-d9b788dc0590
Y2 = hcat(Y, Y)

# ╔═╡ 3a30f360-69d1-11eb-0747-f1cece76ee12
h2 = linear_regression(X2, Y2) # TODO.

# ╔═╡ a687ca20-6a35-11eb-19aa-f78c6f3fa3b8
md"""
# Locally weighted linear regression
"""

# ╔═╡ e61b1e80-6a35-11eb-14a8-d9fe9bba73b1
function regression(X, y, bases)
    B = [b(x) for x in X, b in bases]
    θ = pinv(B)*y
    return x -> sum(θ[i] * bases[i](x) for i in 1:length(θ))
end

# ╔═╡ b02640c0-6a35-11eb-2be3-75294c4b2a0a
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

# ╔═╡ c94a1ae0-6a35-11eb-14d8-51ccabc7fc6d
begin
	D = [(1,1), (2,2), (3,3), (4,3.25), (5,3.5), (6,3.75)]

	g = GroupPlot(3, 1)
	push!(g, plot_polynomial_regression(D, 1))
	push!(g, plot_polynomial_regression(D, 2))
	push!(g, plot_polynomial_regression(D, 5))
	g
end	

# ╔═╡ 22baebb0-9644-11eb-181d-cf8789e088e4
md"""
Newton's method
"""

# ╔═╡ 913f2630-965a-11eb-192d-b7f8b28c771f
# Define tangent line: y = m*(x - x1) + y1
function tangent(m, x, x1, y1)
    return m*(x .- x1) .+ y1
end

# ╔═╡ a84f6290-965a-11eb-343c-91a95c32bc18
tangent(4*4.5, [2.5:0.1:5;], 4.5, 36.5)

# ╔═╡ 669fbfe0-9644-11eb-30ef-298e902dc4c2
function plot_newtons_method()
    @vars x
    f = x -> 2x^2 - 4
    f′ = diff(2x^2 - 4, x)
    origin = Plots.Linear([1, 5], [0, 0], style="black, no marks")
    loss = Plots.Linear(f, (1,5), style="blue")

    x1 = 4.5
    Y::Vector{Float64} = tangent.(f′(x1), [1:5;], x1, f(x1))
    nm1_vert = Plots.Linear([x1, x1], [-10, f(x1)], style="red, dotted, no marks")
    nm1_vert_pt = Plots.Scatter([x1], [f(x1)], style="red", mark="*")
    nm1_tan = Plots.Linear([1:5;], Y, style="red, solid", mark="none")

    x2 = 2.472225 # approx
    nm1_zero_pt = Plots.Scatter([x2], [0.0], style="red, solid", mark="o")

    Y2::Vector{Float64} = tangent.(f′(x2), [1:5;], x2, f(x2))
    nm2_vert = Plots.Linear([x2, x2], [-10, f(x2)], style="purple, dotted, no marks")
    nm2_vert_pt = Plots.Scatter([x2], [f(x2)], style="purple, fill=purple", mark="*")
    nm2_tan = Plots.Linear([1:5;], Y2, style="purple, solid", mark="none")
    
    x3 = 1.64052 # appox
    nm2_zero_pt = Plots.Scatter([x3], [0.0], style="purple, solid", mark="o")
    
    g = GroupPlot(3, 1, style="width=0.3\\textwidth")
    push!(g, Axis([origin, loss], xmin=1, xmax=5, ymin=-10, ymax=60, xlabel=L"x", ylabel=L"f(x)"))
    push!(g, Axis([origin, loss, nm1_vert, nm1_vert_pt, nm1_zero_pt, nm1_tan], xmin=1, xmax=5, ymin=-10, ymax=60, xlabel=L"x"))
    push!(g, Axis([origin, loss, nm1_vert, nm1_tan, nm2_vert, nm2_vert_pt, nm2_tan, nm2_zero_pt, nm1_vert_pt, nm1_zero_pt], xmin=1, xmax=5, ymin=-10, ymax=60, xlabel=L"x"))

    # NOTE: Bug when plots are in this order below. The filled purple turns into a filled gray mark.
    # push!(g, Axis([origin, loss, nm1_vert, nm1_vert_pt, nm1_zero_pt, nm1_tan, nm2_vert, nm2_vert_pt, nm2_tan, nm2_zero_pt], xmin=1, xmax=5, ymin=-10, ymax=60, xlabel=L"x"))
    return g
end

# ╔═╡ 70abcdee-965b-11eb-3c1b-a1329f72e3c7
tangent(4*4.5, 2.472225, 4.5, 36.5)

# ╔═╡ a1f5f2e2-965c-11eb-23bb-7134b836296b
tangent(4*2.472225, 1.64052, 2.472225, 2*2.472225^2 - 4)

# ╔═╡ bfb58920-9644-11eb-0e7b-133e428223f4
fp = plot_newtons_method()

# ╔═╡ 33d67960-9b43-11eb-2aa1-538e79d1e1b6
save("newton.tex", fp)

# ╔═╡ e8632700-9659-11eb-375d-e5071cf7d225
(4.5, 2*4.5^2 - 4)

# ╔═╡ Cell order:
# ╠═92728d70-69b5-11eb-2c45-33f34641f0a8
# ╠═62598390-69b6-11eb-19b7-119b6c33cf22
# ╠═28d38fce-69b6-11eb-25ef-3d4496868f01
# ╟─0aa9b2f0-69b6-11eb-366a-e737fc6fb8fd
# ╠═e5cac3c0-69b5-11eb-215d-d726379edcdc
# ╠═a7f4ba50-69b6-11eb-2dd1-53bffb85613a
# ╠═af9f9e50-69b6-11eb-3f9a-f1bfe7d4e1d0
# ╠═a472b4f0-69b5-11eb-3374-65f8c9450019
# ╟─64527d50-69ca-11eb-2df0-21c8ba5224b0
# ╠═73c2d230-69ca-11eb-0501-3f5888d0ba3a
# ╠═bdc49760-69ca-11eb-3590-d959c2e3007f
# ╠═9bcdd400-69ca-11eb-35f4-53fc0ff06b7e
# ╠═9a20c03e-69ca-11eb-3775-db0d1647ea9e
# ╟─5d9afd30-69ce-11eb-1332-b39a334600ad
# ╠═60464710-69ce-11eb-269b-971338ea455e
# ╠═da30aff0-69d0-11eb-188e-ed08ff5a238b
# ╠═eeb20410-69d0-11eb-3927-ff57dc94e7c9
# ╠═dc4d7570-69d0-11eb-1d72-43ff72da44e5
# ╠═658a8b50-69ce-11eb-0f31-2741a6b8f0c9
# ╠═82641a70-69ce-11eb-300b-3dbde391c20f
# ╠═1cc27740-69d1-11eb-3988-bd4a299969e9
# ╠═44d76420-69d1-11eb-0672-d9b788dc0590
# ╠═3a30f360-69d1-11eb-0747-f1cece76ee12
# ╟─a687ca20-6a35-11eb-19aa-f78c6f3fa3b8
# ╠═ab94d1c0-6a35-11eb-2c69-8bd95ad0c0cd
# ╠═f5f028a0-6a35-11eb-33fa-f3b07ad5b5c6
# ╠═e61b1e80-6a35-11eb-14a8-d9fe9bba73b1
# ╠═b02640c0-6a35-11eb-2be3-75294c4b2a0a
# ╠═c94a1ae0-6a35-11eb-14d8-51ccabc7fc6d
# ╠═22baebb0-9644-11eb-181d-cf8789e088e4
# ╠═41928830-9659-11eb-34ee-134854f44e89
# ╠═913f2630-965a-11eb-192d-b7f8b28c771f
# ╠═a84f6290-965a-11eb-343c-91a95c32bc18
# ╠═669fbfe0-9644-11eb-30ef-298e902dc4c2
# ╠═70abcdee-965b-11eb-3c1b-a1329f72e3c7
# ╠═a1f5f2e2-965c-11eb-23bb-7134b836296b
# ╠═bfb58920-9644-11eb-0e7b-133e428223f4
# ╠═33d67960-9b43-11eb-2aa1-538e79d1e1b6
# ╠═e8632700-9659-11eb-375d-e5071cf7d225

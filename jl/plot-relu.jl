### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 7462ff30-a2b4-11eb-37c7-71713fa49207
begin
	using PGFPlots
	using LinearAlgebra # for dot: ⋅
	using DataFrames
	using CSV
end

# ╔═╡ 4a1a9080-a2b4-11eb-0c98-4936b576c461
include("support_code.jl")

# ╔═╡ 5c6a85b0-a2b4-11eb-13a0-5f4bee5cf181
begin
	relu = x->max(0,x)
	data = CSV.read("..\\data\\portland-houses.csv", DataFrame; header=["area", "bedrooms", "price"])
	X = data[:area]
	Y = data[:price] ./ 1000
	
	# rotate for better ReLU visualization
	R = θ->[cosd(θ) -sind(θ); sind(θ) cosd(θ)]
	origin = [1500, 2000]
	θ = 20

	XY = R(θ)*hcat(X.-origin[1],Y.-origin[2])' .+ origin
	X′ = XY[1,:]
	Y′ = XY[2,:]

	h = linear_regression(X′, Y′)

	p_data = Plots.Scatter(X′, Y′, style="mark=x")
	xmax = maximum(X′) + 500
	xn = 0:xmax
	ymax = maximum(Y′) + 250

	p_fit = Plots.Linear(xn, relu.(h.(xn)), style="thick, blue!50!black, no marks")

	Axis([p_data, p_fit], title="housing prices", xlabel="square feet", ylabel="price (in \\\$1000)", xmin=0, xmax=xmax, ymin=-50, ymax=ymax)
end

# ╔═╡ Cell order:
# ╠═7462ff30-a2b4-11eb-37c7-71713fa49207
# ╠═4a1a9080-a2b4-11eb-0c98-4936b576c461
# ╠═5c6a85b0-a2b4-11eb-13a0-5f4bee5cf181

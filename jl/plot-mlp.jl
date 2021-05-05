### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 3dda7350-a2bc-11eb-3919-1f06010efe65
begin
	using PGFPlots
	using LinearAlgebra # for dot: ⋅
	using DataFrames
	using CSV
end

# ╔═╡ 4b966170-a2bc-11eb-150b-6bdc3d6d85c7
using Revise; using TikzNeuralNetworks

# ╔═╡ 456e4ce0-a2bc-11eb-323a-abc67054dc7d
include("support_code.jl")

# ╔═╡ 58cd8f2e-a2bc-11eb-1e6d-496a248dca90
nn = TikzNeuralNetwork(input_size=3,
                       input_arrows=false,
					   input_label=i->"\$x_{$i}\$",
                       hidden_layer_sizes=[4],
	                   hidden_layer_labels=(h,i)->["\$a_$j\$" for j in 1:i],
                       output_size=1,
	                   output_label=i->L"h_\theta(x)",
                       output_arrows=false,
                       node_size="20pt")

# ╔═╡ 97801920-a2bf-11eb-39d6-f5c87ec32b48
nn2 = TikzNeuralNetwork(input_size=3, hidden_layer_sizes=[2, 4], hidden_layer_labels=(h,i)->["{\\scriptsize\$a_{$j}^{[$h]}\$}" for j in 1:i], activation_functions=["sigmoid", "function"], node_size="24pt")

# ╔═╡ Cell order:
# ╠═3dda7350-a2bc-11eb-3919-1f06010efe65
# ╠═456e4ce0-a2bc-11eb-323a-abc67054dc7d
# ╠═4b966170-a2bc-11eb-150b-6bdc3d6d85c7
# ╠═58cd8f2e-a2bc-11eb-1e6d-496a248dca90
# ╠═97801920-a2bf-11eb-39d6-f5c87ec32b48

### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 1e4e4650-a2c7-11eb-284d-2b5573250fcf
begin
	using PGFPlots
	using LinearAlgebra # for dot: ⋅
	using DataFrames
	using CSV
	using Distributions
end

# ╔═╡ 12cee540-a2c8-11eb-3167-87ad7c1f62d9
begin
	using Colors
	using ColorSchemes
	pasteljet = ColorMaps.RGBArrayMap(ColorSchemes.viridis, interpolation_levels=500, invert=true);
end

# ╔═╡ c0c66070-a2c7-11eb-0b7c-bf6c6a9169dc
function format_sigma(s)
	try
		return Int(s)
	catch e
		return s
	end
end

# ╔═╡ 35adc940-a2c9-11eb-2906-754e508bdb0b
resetPGFPlotsPreamble()

# ╔═╡ c8e8a1e2-a2c8-11eb-2173-35442d3ab4f4
pushPGFPlotsPreamble("\\usepackage{amsmath}")

# ╔═╡ 0195e8e0-a2c9-11eb-1c6f-636668274d1d
pushPGFPlotsPreamble("\\usepackage{../../tex/vector}")

# ╔═╡ 3c443000-a2c9-11eb-1c58-ff5995478cda
pushPGFPlotsPreamble(raw"""
\newcommand{\mat}[1]{\vect{#1}}
\renewcommand{\vec}[1]{\vect{#1}}""")

# ╔═╡ e27f7e90-a2c7-11eb-02ef-0ff25839c21f
begin
	p = GroupPlot(3, 1, groupStyle="horizontal sep=1cm, y descriptions at=edge left")
	for (i, (mu, sigma)) in enumerate([([0,0],[1 0; 0 1]),
									   ([0,0],[1 0.5; 0.5 1]),
									   ([0,0],[1 0.8; 0.8 1])])
		push!(p, Axis(
			Plots.Image((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5),
						zmin=0, zmax=0.05, xbins=151, ybins=151, colormap=pasteljet, colorbar=(i==4),
						colorbarStyle="width=2mm"
				), height="4.5cm", width="4.5cm",
				title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
				style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
	end
	p
end

# ╔═╡ e9e3ea10-a2cf-11eb-210a-6374f404a3f8
begin
	p2 = GroupPlot(3, 1, groupStyle="horizontal sep=1cm, y descriptions at=edge left")
	for (i, (mu, sigma)) in enumerate([([0,0],[3 0.8; 0.8 3]),
									   ([0,0],[1 -0.5; -0.5 1]),
									   ([0,0],[1 -0.8; -0.8 1])])
		push!(p2, Axis(
			Plots.Image((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5),
						zmin=0, zmax=0.05, xbins=151, ybins=151, colormap=pasteljet, colorbar=(i==4),
						colorbarStyle="width=2mm"
				), height="4.5cm", width="4.5cm",
				title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
				style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
	end
	p2
end

# ╔═╡ 964fd150-a2d1-11eb-1627-05722e53dbfd
begin
	p3 = GroupPlot(3, 1, groupStyle="horizontal sep=1cm, y descriptions at=edge left")
	for (i, (mu, sigma)) in enumerate([([0,0],[1 0; 0 1]),
									   ([0,0],[1 0.5; 0.5 1]),
									   ([0,0],[1 0.8; 0.8 1])])
		push!(p3, Axis(
			Plots.Contour((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5), labels=false, style="colormap={reverse viridis}{ indices of colormap={ \\pgfplotscolormaplastindexof{viridis},...,0 of viridis} }",
						# zmin=0, zmax=0.05, xbins=151, ybins=151, colormap=pasteljet, colorbar=(i==4),
						# colorbarStyle="width=2mm"
				), height="4.5cm", width="4.5cm", xmin=-3, xmax=3, ymin=-3, ymax=3,
				title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
				style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
	end
	p3
end

# ╔═╡ ee0503b0-a2d2-11eb-0b14-456886c84951
begin
        heatmap = false
        p99 = GroupPlot(3, 1, groupStyle="horizontal sep=1cm, y descriptions at=edge left")
        for (i, (mu, sigma)) in enumerate([([0,0],[1 0; 0 1]),
                                           ([0,0],[1 0.5; 0.5 1]),
                                           ([0,0],[1 0.8; 0.8 1])])
            if heatmap
                push!(p99, Axis(
                    Plots.Image((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5),
                                zmin=0, zmax=0.05, xbins=151, ybins=151, colormap=pasteljet, colorbar=(i==4),
                                colorbarStyle="width=2mm"
                        ), height="4.5cm", width="4.5cm",
                        title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
                        style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
            else
                push!(p99, Axis(
                    Plots.Contour((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5), labels=false, style="colormap={reverse viridis}{ indices of colormap={ \\pgfplotscolormaplastindexof{viridis},...,0 of viridis} }"),
                    height="4.5cm", width="4.5cm", xmin=-3, xmax=3, ymin=-3, ymax=3,
                    title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
                    style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
            end
        end
        p99
end

# ╔═╡ Cell order:
# ╠═1e4e4650-a2c7-11eb-284d-2b5573250fcf
# ╠═c0c66070-a2c7-11eb-0b7c-bf6c6a9169dc
# ╠═12cee540-a2c8-11eb-3167-87ad7c1f62d9
# ╠═35adc940-a2c9-11eb-2906-754e508bdb0b
# ╠═c8e8a1e2-a2c8-11eb-2173-35442d3ab4f4
# ╠═0195e8e0-a2c9-11eb-1c6f-636668274d1d
# ╠═3c443000-a2c9-11eb-1c58-ff5995478cda
# ╠═e27f7e90-a2c7-11eb-02ef-0ff25839c21f
# ╠═e9e3ea10-a2cf-11eb-210a-6374f404a3f8
# ╠═964fd150-a2d1-11eb-1627-05722e53dbfd
# ╠═ee0503b0-a2d2-11eb-0b14-456886c84951

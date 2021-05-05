# Any imports you need go here.
using PGFPlots
using LinearAlgebra # for dot: ⋅
using DataFrames
using Distributions
using CSV
using TikzNeuralNetworks

include("../output/all_algorithm_blocks.jl")
include("gradient_descent.jl")
include("linear_regression.jl")
include("locally_weighted_linear_regression.jl")
include("newtons_method.jl")

# For multivariate Gaussian labels
function format_sigma(s)
    try
        return Int(s)
    catch e
        return s
    end
end

function mv_gaussian_plot(Σs; heatmap=false)
    p = GroupPlot(3, 1, groupStyle="horizontal sep=1cm, y descriptions at=edge left")
    for (i, (mu, sigma)) in enumerate(Σs)
        if heatmap
            push!(p, Axis(
                Plots.Image((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5),
                            zmin=0, zmax=0.05, xbins=151, ybins=151, colormap=pasteljet, colorbar=(i==4),
                            colorbarStyle="width=2mm"
                    ), height="4.5cm", width="4.5cm",
                    title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
                    style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
        else
            push!(p, Axis(
                Plots.Contour((x,y)->pdf(MvNormal(mu,Float64.(sigma)), [x,y]), (-5,5), (-5,5),
                              labels=false,
                              style="colormap={reverse viridis}{ indices of colormap={ \\pgfplotscolormaplastindexof{viridis},...,0 of viridis} }"),
                height="4.5cm", width="4.5cm", xmin=-4, xmax=4, ymin=-4, ymax=4,
                title="{\\footnotesize\\shortstack{\$\\vec \\mu=[$(mu[1]),$(mu[2])]\$\\\\\$\\mat \\Sigma=\\begin{bmatrix}$(format_sigma(sigma[1,1])) & $(format_sigma(sigma[1,2]))\\\\$(format_sigma(sigma[2,1])) & $(format_sigma(sigma[2,2]))\\end{bmatrix}\$}}",
                style="colorbar style={scaled y ticks=false,yticklabel style={/pgf/number format/.cd, fixed, fixed zerofill, precision=2, /tikz/.cd}}"))
        end
    end
    return p
end

# Any other supporting code you need goes here.

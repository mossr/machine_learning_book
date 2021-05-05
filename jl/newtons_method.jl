using SymEngine

# Define tangent line: y = m*(x - x1) + y1
function tangent(m, x, x1, y1)
    return m*(x .- x1) .+ y1
end


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
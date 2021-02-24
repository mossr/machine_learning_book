using SymEngine

# Gradient descent/ascent step functions
import Base.step
step(a, t, ∇f) = a + t*∇f(a) # Return updated step
step!(a, t, ∇f) = a[:] = a + t*∇f(a) # Update a in place


function gradient_descent(f; vars=free_symbols(f), n=length(vars), a=zeros(n), t=-0.1, epsilon=1e-10, max_iters=10_000)
    gradient_vector::Vector = diff.(f, vars) # Gradient vector: list of partial derivatives (general case for any n)
    ∇f(a::Vector) = map(fᵢ->fᵢ(Pair.(vars,a)...), gradient_vector) # Call the gradients given an input vector a (call diff using var=>value syntax to ensure variables line up)
    final_iteration = 0 # Last iteration at convergence
    local gradient_value::Vector{Float64} # Value of gradient displayed when converged
    for i in 1:max_iters
        a′::Vector{Float64} = step(a, t, ∇f) # Compute step towards steepest descent
        converge::Bool = all(abs.(a′ - a) .< fill(epsilon, n)) # Check for convergence
        a = a′ # Update step
        if converge
            gradient_value = ∇f(a)
            # println("Converged at iteration $i: $a (where ∇f(a) = $gradient_value)")
            break
        elseif i == max_iters
            gradient_value = ∇f(a)
            # println("Reached max iterations of $i: $a (where ∇f(a) = $gradient_value)")
        end
    end
    return a
end

function plot_gradient_descent(f; initial=[1,0.], path_length=10, output=false)
    path1 = initial
    for s in 1:path_length
        path1 = hcat(path1, gradient_descent(f, max_iters=s, a=initial))
    end

    # Generate gradient arrows
    after_end_axis_content = ""
    for i in 1:size(path1,2)-1
        a = path1[:,i]
        a2 = path1[:,i+1]
        after_end_axis_content *= "\\draw[blue,->] (axis cs:$(a[1]),$(a[2])) -- (axis cs:$(a2[1]),$(a2[2]));"
    end

    after_end_axis = "after end axis/.code={$after_end_axis_content}"

    p = Axis([
        Plots.Linear([path1[1,1]], [path1[2,1]], markSize=1, mark="*"),
        Plots.Contour((x,y)->f(x,y), (-50,50), (-50,50), labels=false, levels=vcat([0], [100:200:600;], [800:400:4000;]), style="colormap/viridis")
    ], style="view={0}{90}, $after_end_axis")
    if output
        save("gd.pdf", p)
    end
    return p
end


# CODE INSIDE LATEX.
#=
@vars x, y
f = x^2/2 + y^2
plot_gradient_descent(f, initial=[48, 30], path_length=30)
=#

using MiniBee
using Plots

function plot_trajectory()
    xs = []
    ys = []
    v::Float64 = 2.5
    x, y = 0., 0.
    dt = 0.1
    @gif for t::Float64 in 1:dt:10
        θ = π/4 + sin(t)
        xy = twobodies(v, θ)
        x += xy[1] * dt
        y += xy[2] * dt
        push!(xs, x)
        push!(ys, y)
        p = plot(xs, ys, xlims=(0., 15.), ylims=(0., 15.))
    end
end

plot_trajectory()

module MiniBee

using LinearAlgebra, RobotDynamics, TrajectoryOptimization, StaticArrays, Rotations, Parameters, Altro, Sockets, JSON
import RobotDynamics: mass, inertia, forces, moments

include("inertia.jl")
include("spacecraft.jl")
include("waypoints.jl")
include("costs.jl")
include("problem.jl")
include("postprocessing.jl")

"""
Build a problem, solve it and return a `SpacecraftTrajectory` to be used in postprocessing.
"""
function main(model, opts, N, tf, dt, xf_pos, u0; waypoints=[])
    
    prob = build_problem(model, N, tf, dt, xf_pos, u0; waypoints)

    solver = ALTROSolver(prob, opts)
    solve!(solver)
    x = states(solver)
    u = controls(solver)
    @show size(x)
    @show size(u)
    x_mat, u_mat = hcat(Array.(x)...), hcat(Array.(u)...)
    postprocess(solver, x_mat, u_mat)
    println(size(u_mat))
    time = vcat(0, cumsum(dt))
    SpacecraftTrajectory(x_mat, u_mat, time)
end

export main,
       Spacecraft,
       postprocess,
       look_for_port,
       Waypoint

end # module
struct SpacecraftTrajectory
    position::Array{Float64, 2}
    attitude::Array{Float64, 2}
    velocity::Array{Float64, 2}
    angular_velocity::Array{Float64, 2}
    thrust::Array{Float64, 2}
    angular_controls::Array{Float64, 2}
    time
    SpacecraftTrajectory(states, controls, time) = new(
        states[1:3, :],
        states[4:7, :],
        states[7:9, :],
        states[10:12, :],
        controls[1:1, :],
        controls[2:4, :],
        time)
end

function Base.write(model::Spacecraft, traj::SpacecraftTrajectory, filename)
    dict = Dict(
        "$name" => getproperty(traj, name) for name ∈ fieldnames(SpacecraftTrajectory)
    )
    open(filename, "w") do io
        write(io, json(dict))
    end
end

function postprocess(solver, x, u)
    println("Cost: ", cost(solver))
    println("Constraint violation: ", max_violation(solver))
    println("Iterations: ", iterations(solver))
    println("Final state: ", x[:, end])
    println("Maximum control: ", maximum(u))
end
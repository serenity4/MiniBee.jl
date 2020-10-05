struct Spacecraft <: RigidBody{UnitQuaternion}
    n::Int
    m::Int
    dry_mass::Float64
    fuel::Float64
    dimensions::SVector{3, Float64}
    gravity::SVector{3,Float64}
    kt::Float64
    max_thrust::Float64
    max_amplitude_angular_control::Float64
    info::Dict{Symbol,Any}
    Spacecraft(; n=13, m=4, dry_mass=500, fuel=300, dimensions=SA[1., 1., 1.], gravity=SA[0, 0, -9.81], kt=1., max_thrust=1e3, max_amplitude_angular_control=10., info=Dict()) = new(n, m, dry_mass, fuel, dimensions, gravity, kt, max_thrust, max_amplitude_angular_control, info)
end

RobotDynamics.control_dim(::Spacecraft) = 4

function forces(model::Spacecraft, x, u)
    q = orientation(model, x)
    F = @SVector [model.kt * u[1], 0., 0.]
    q*F# + mass(model) * model.gravity
end

function moments(model::Spacecraft, x, u)
    m = mass(model)
    @SVector [u[2], u[3], u[4]]
end

function inertia(model::Spacecraft)
    inertia_cuboid(model.dimensions..., mass(model))
end

function mass(model::Spacecraft)
    model.dry_mass + model.fuel
end
function build_problem(model::Spacecraft, N, tf, dt, xf_pos, u0; waypoints=[])
    n, m = size(model)
    x0_pos = SA[0, 0, 0.]
    x0 = RobotDynamics.build_state(model, x0_pos, UnitQuaternion(I), zeros(3), zeros(3))
    xf = RobotDynamics.build_state(model, xf_pos, UnitQuaternion(I), zeros(3), zeros(3))

    push!(waypoints, Waypoint(xf_pos, N))

    @show x0
    @show xf

    Q = Diagonal(RobotDynamics.fill_state(model, 0., 0., 0., 0.))
    R = Diagonal(@SVector [1 / mass(model), 1, 1, 1])
    Qw = Diagonal(RobotDynamics.fill_state(model, 1000., 0., 0., 0.))
    obj = Objective(TrajectoryCost(N, combine(LQR(Q, R, model), WaypointsLQR(waypoints, Qw, R, model))))

    
    conSet = ConstraintList(n,m,N)
    x_min = repeat([-Inf], n)
    x_max = -x_min
    u_min = vcat(0., repeat([-model.max_amplitude_angular_control], 3))
    u_max = vcat(model.max_thrust, repeat([model.max_amplitude_angular_control], 3))

    add_constraint!(conSet, BoundConstraint(n,m; u_min, u_max, x_min, x_max), 1:N-1)
    # add_constraint!(conSet, GoalConstraint(xf), N)
    # wp = getproperty.(waypoints, :location)
    # add_constraint!(conSet, SphereConstraint(n, getindex.(wp, 1), [getindex.(wp, i) for i ∈ 1:length(wp)]..., repeat([10.], length(waypoints))), 1:N-1)
    
    prob = Problem(model, obj, xf, tf, x0=x0, constraints=conSet, dt=dt)
    initial_controls!(prob, u0)
    rollout!(prob)
    prob
end
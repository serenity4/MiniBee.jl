using Plots
using MiniBee
using TrajectoryOptimization
using StaticArrays
using Sockets
using Altro

model = Spacecraft(kt=1, max_thrust=10000, max_amplitude_angular_control=100)

tf = 10.
N = 100
xf_pos = SA[100, 0, 100.]
waypoints = Waypoint.([
    SA[60, 0., 40],
    SA[75, 0., 80],
], [33, 66])   # in knot points
dt = repeat([tf/(N-1)], N-1)
u0 = [copy(SA[1000.0, 0, 1., 0.]) for k = 1:N-1]

opts = SolverOptions(
    penalty_scaling=5.,
    penalty_initial=10.,
    constraint_tolerance=1e-5,
    # penalty_max=
)

# lgl_nodes = remap.(gausslobatto(N)[1], Ref([-1, 1]), Ref([0, tf]))
# dt = lgl_nodes[2:end] - lgl_nodes[1:end-1]


traj = main(model, opts, N, tf, dt, xf_pos, u0)

write(model, traj, "mini_bee_data.json")

plot(traj.time, traj.position', title="(t₀=0, tf=$tf) - $N points", legend=:topleft)
plot(traj.time[1:end-1], traj.thrust', title="Thrust")
plot(traj.time[1:end-1], traj.angular_controls', title="Angular controls")
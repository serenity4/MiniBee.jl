"""
Cost model typically used in an Objective function.
"""
abstract type CostModel end

"""
Cost that does not rely on any particular discretization.
"""
abstract type ContinuousCost <: CostModel end

"""
Punctual cost, that is only evaluated at designated points.
"""
abstract type PointCost <: CostModel end

"""
Linear Quadratic Regulator model.
"""
struct LQR <: ContinuousCost
    Q
    R
    nominal_state
end

function LQR(Q, R, model::Spacecraft; target_location=zeros(3))
    x_nom = RobotDynamics.build_state(model, target_location, UnitQuaternion(I), zeros(3), zeros(3))
    LQR(Q, R, x_nom)
end

TrajectoryOptimization.cost(cm::LQR) = LQRCost(cm.Q, cm.R, cm.nominal_state)

"""
LQR cost associated with waypoints, only at node points designed by integer indices in `times`.
"""
struct WaypointsLQR <: PointCost
    times
    costs
    function WaypointsLQR(waypoints, Q, R, model)
        costs = map(waypoints) do wp
            @show wp
            cost(LQR(Q, R, model; target_location=wp.location))
        end
        new(getproperty.(waypoints, :time), costs)
    end
end

"""
Cost structure holding a function that can be evaluated with the number of discretization points as argument to create a vector of costs.
"""
struct DiscretizeableCost <: CostModel
    discretization_f
end

function combine(cc::ContinuousCost, pc::PointCost)
    function discretize_cost(N)
        cost_1 = cost(cc)
        costs_all = map(1:N) do k
            i = findfirst(pc.times .== k)
            !isnothing(i) ? pc.costs[i] : cost_1
        end
    end
    DiscretizeableCost(discretize_cost)
end

"""
Structure holding a vector of point costs.
"""
struct TrajectoryCost
    costs
end
TrajectoryCost(N, cost_model::ContinuousCost) = TrajectoryCost(repeat([cost(cost_model)], N))
TrajectoryCost(N, cost_model::DiscretizeableCost) = TrajectoryCost(cost_model.discretization_f(N))

TrajectoryOptimization.Objective(t::TrajectoryCost) = Objective(t.costs)
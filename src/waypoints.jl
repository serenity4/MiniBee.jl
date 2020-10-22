"""
Intermediary point along the trajectory.
"""
struct Waypoint
    location
    time
end

Base.broadcastable(x::Waypoint) = Ref(x)
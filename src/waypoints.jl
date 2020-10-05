struct Waypoint
    location
    time
end

Base.broadcastable(x::Waypoint) = Ref(x)
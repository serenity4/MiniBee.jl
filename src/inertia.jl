
"Inertia matrix of a uniformly dense cuboid with mass `m`"
inertia_cuboid(length, width, thickness, m) = m / 12 * Diagonal(@SVector [width^2 + thickness^2, length^2 + thickness^2, length^2 + width^2])

"Inertia matrix of a uniformly dense thick cylinder with inner and outer radii `r1` and `r2`, height `h` and mass `m`"
inertia_thick_cylinder(r1, r2, h, m) = Diagonal(@SVector [ 1 / 12 * m * (3 * (r2^2 + r1^2) + h^2), 1 / 12 * m * (3 * (r2^2 + r1^2) + h^2), m * (r2^2 + r1^2) / 2])
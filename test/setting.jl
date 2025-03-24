
param = CFD2d.Parameter(64, 64, 2π, 2π, 1000.0, 10.0, 0.01)

@test param.LIQUID == 0
@test param.PFIX_BC == 1
@test param.VFIX_BC == 2
@test param.WALL_BC == 3
@test param.ONWALL_BC == 4
@test param.ISOLATED_BC == 9

@test param.n == (64, 64)
@test param.L == (2π, 2π)
@test param.ρ == 1000
@test param.ν == 0.01
@test param.Δt == 0.01
@test param.Δx == 2π / 64
@test param.Δy == 2π / 64
@test param.x == range(0, stop=2π, length=64)
@test param.y == range(0, stop=2π, length=64)


field = CFD2d.Field(param)

@test field.u == zeros(Float64, 64, 64)
@test field.v == zeros(Float64, 64, 64)
@test field.p == zeros(Float64, 64, 64)
@test field.bc_u == zeros(Int64, 64, 64)
@test field.bc_v == zeros(Int64, 64, 64)
@test field.bc_p == zeros(Int64, 64, 64)

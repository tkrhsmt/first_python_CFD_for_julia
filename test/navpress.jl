
param = CFD2d.Parameter(10, 10, 5.0, 1.0, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)
condition = CFD2d.Channel()

CFD2d.initialize(param, field, condition)

for j in 1:param.n[2]
    for i in 1:param.n[1]
        field.p[i, j] = float(i)
    end
end

CFD2d.calc_pressure_term!(param, field)

answer = -param.Δt / (param.Δx * param.ρ)
CFD2d.array_rank(field.Δu, "Δu", param)
@test field.Δu[2, 2] ≈ answer


param = CFD2d.Parameter(10, 10, 5.0, 1.0, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)
condition = CFD2d.Channel()
CFD2d.initialize(param, field, condition)
CFD2d.add_viscos_term!(param, field)
CFD2d.array_rank(field.Δu, "Δu", param)

@test field.Δu[2, 2] ≈ -0.0012

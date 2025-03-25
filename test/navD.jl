
param = CFD2d.Parameter(10, 8, 2.0, 2.0, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)
condition = CFD2d.Channel()
CFD2d.initialize(param, field, condition)

for j in 1:param.n[2]
    for i in 1:param.n[1]
        field.u[i, j] = param.x[i] * 0.001
    end
end

CFD2d.calc_div!(param, field)
CFD2d.array_rank(field.∇u, "∇u", param)

@test field.∇u[2, 2] ≈ 100.0

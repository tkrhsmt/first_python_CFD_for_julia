
param = CFD2d.Parameter(10, 8, 2.0, 2.0, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)

for j in 1:param.n[2]
    for i in 1:param.n[1]
        field.u[i, j] = float(param.x[i]^2 + param.y[j]^2)
    end
end

CFD2d.array_rank(field.u, "u", param)

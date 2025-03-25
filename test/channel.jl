
param = CFD2d.Parameter(30, 30, 5.0, 1.0, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)
condition = CFD2d.Channel()

step = 10

CFD2d.initialize(param, field, condition)
for st in 1:step
    CFD2d.smac(param, field)
    println("step: $(st)")
end

CFD2d.array_rank(field.p, "p", param)

p_max = 120 * (param.L[1] - 2 * param.Δx)
@test ceil(field.p[1, 15]) == ceil(p_max)


param = CFD2d.Parameter(10, 8, 2.0, 2.0, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)
condition = CFD2d.Channel()

CFD2d.initialize(param, field, condition)
tmp = CFD2d.array_rank(field.u, "distribution of u", param)
@test tmp == [
    "0000000000",
    "4444444440",
    "8888888880",
    "9999999990",
    "9999999990",
    "8888888880",
    "4444444440",
    "0000000000",
]

tmp = CFD2d.array_rank(field.bc_p, "bc-code-p", param)
@test tmp == [
    "9333333399",
    "2000000019",
    "2000000019",
    "2000000019",
    "2000000019",
    "2000000019",
    "2000000019",
    "9333333399",
]

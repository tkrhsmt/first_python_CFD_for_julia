
param = CFD2d.Parameter(10, 10, 2π, 2π, 1000.0, 10.0, 0.01)
field = CFD2d.Field(param)

field.bc_p[:, 1] .= param.WALL_BC
field.bc_p[:, end] .= param.PFIX_BC
field.bc_p[1, :] .= param.VFIX_BC
field.bc_p[end, :] .= param.WALL_BC

field.bc_p[4:6, 4:6] .= param.WALL_BC

CFD2d.set_code_ref!(param, field)

CFD2d.visu_arr(field.bc_p')
CFD2d.visu_arr(field.bc_u')
CFD2d.visu_arr(field.bc_v')

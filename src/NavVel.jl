
function modify_velocity!(
    param:: Parameter,
    field:: Field,
)
    field.u .+= field.Δu
    field.v .+= field.Δv
    set_velocity_bc!(param, field.u, field.bc_u, field.ref_u)
    set_velocity_bc!(param, field.v, field.bc_v, field.ref_v)
end

function set_velocity_bc!(
    param:: Parameter,
    velocity:: Array{Float64, 2},
    bc:: Array{Int64, 2},
    ref:: Matrix{Vector{Int64}}
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]

            if bc[i, j] == param.PFIX_BC
                velocity[i, j] = velocity[ref[i, j][1], ref[i, j][2]]
            elseif bc[i, j] == param.WALL_BC
                velocity[i, j] = 0.0
            elseif bc[i, j] == param.ONWALL_BC
                velocity[i, j] = 0.0
            elseif bc[i, j] == param.VFIX_BC
                #velocity[i, j] = 0.0
            end

        end
    end
end

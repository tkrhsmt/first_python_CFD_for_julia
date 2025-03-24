
function cleanup!(
    param:: Parameter,
    field:: Field
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]
            field.bc_p[i, j] = param.LIQUID
            field.bc_u[i, j] = param.LIQUID
            field.bc_v[i, j] = param.LIQUID

            field.ref_p[i, j] = [-1, -1]
            field.ref_u[i, j] = [-1, -1]
            field.ref_v[i, j] = [-1, -1]
        end
    end
end

function set_bccode_p!(
    ii0:: Int64,
    ii1:: Int64,
    jj0:: Int64,
    jj1:: Int64,
    code:: Int64,
    field:: Field
)
    field.bc_p[ii0:ii1, jj0:jj1] .= code
end

function set_code_ref!(
    param:: Parameter,
    field:: Field
)
    # set bc_code and bc_ref automatically
    set_code_vel_u!(param, field)
    set_code_vel_v!(param, field)

    modify_pfix_east!(param, field)
    set_isolated!(param, field)

    set_ref!(param, field.ref_p, field.bc_p)
    set_ref!(param, field.ref_u, field.bc_u)
    set_ref!(param, field.ref_v, field.bc_v)
end

function set_code_vel_u!(
    param:: Parameter,
    field:: Field
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]

            if i == param.n[1]
                field.bc_u[i, j] = param.ISOLATED_BC
                continue
            end

            bc0 = minimum([field.bc_p[i, j], field.bc_p[i+1, j]])
            bc1 = maximum([field.bc_p[i, j], field.bc_p[i+1, j]])

            if bc0 == bc1
                field.bc_u[i, j] = bc0
            elseif bc0 == param.LIQUID && bc1 != param.LIQUID
                if bc1 == param.WALL_BC
                    bc1 = param.ONWALL_BC
                end
                field.bc_u[i, j] = bc1
            end
        end
    end
end

function set_code_vel_v!(
    param:: Parameter,
    field:: Field
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]

            if j == param.n[2]
                field.bc_v[i, j] = param.ISOLATED_BC
                continue
            end

            bc0 = minimum([field.bc_p[i, j], field.bc_p[i, j+1]])
            bc1 = maximum([field.bc_p[i, j], field.bc_p[i, j+1]])

            if bc0 == bc1
                field.bc_v[i, j] = bc0
            elseif bc0 == param.LIQUID && bc1 != param.LIQUID
                if bc1 == param.WALL_BC
                    bc1 = param.ONWALL_BC
                end
                field.bc_v[i, j] = bc1
            end
        end
    end
end

function set_ref!(
    param:: Parameter,
    bc_ref:: Matrix{Vector{Int64}},
    bc_code:: Array{Int64, 2}
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]

            if bc_code[i, j] != param.LIQUID
                ref = search_liquid_around(bc_code, i, j, param)
                if ref[1] > 0 && ref[2] > 0
                    bc_ref[i, j] = ref
                else
                    bc_ref[i, j] = [-1, -1]
                    bc_code[i, j] = param.ISOLATED_BC
                end
            end
        end
    end
end

function set_isolated!(
    param:: Parameter,
    field:: Field
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]
            ref = search_liquid_around(field.bc_p, i, j, param)
            if ref[1] < 0
                field.bc_p[i, j] = param.ISOLATED_BC
            end
        end
    end
end

function search_liquid_around(
    bc_code:: Array{Int64, 2},
    i:: Int64,
    j:: Int64,
    param:: Parameter
)

    neighbors = [(i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)]

    for index ∈ neighbors
        ii = index[1]
        jj = index[2]
        if 1 <= ii <= param.n[1] && 1 <= jj <= param.n[2]
            if bc_code[ii, jj] == param.LIQUID
                return [ii, jj]
            end
        end
    end

    return [-1, -1]
end

function modify_pfix_east!(
    param:: Parameter,
    field:: Field
)
    field.bc_p[end - 1, :] .= param.PFIX_BC
end

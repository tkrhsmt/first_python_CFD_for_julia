# =============================================================================
# channel flow
# =============================================================================

struct Channel <: AbstractFlow end

function initialize(
    param:: Parameter,
    field:: Field,
    flow:: Channel
)
    cleanup!(param, field)
    set_bccode!(param, field, flow)
    set_code_ref!(param, field)
    set_init_condition!(param, field, flow)
end

function set_bccode!(
    param:: Parameter,
    field:: Field,
    flow:: Channel
)
    field.bc_p[1, 2:param.n[2] - 1] .= param.VFIX_BC
    field.bc_p[2:param.n[1] - 1, 1] .= param.WALL_BC
    field.bc_p[2:param.n[1] - 1, param.n[2]] .= param.WALL_BC
    field.bc_p[param.n[1], 2:param.n[2] - 1] .= param.PFIX_BC
end

function set_init_condition!(
    param:: Parameter,
    field:: Field,
    flow:: Channel
)
    field.v[:, :] .= 0.0
    field.p[:, :] .= 0.0

    height = param.L[2]
    for j in 1:param.n[2]
        for i in 1:param.n[1]
            if field.bc_u[i, j] ∈ [param.LIQUID, param.VFIX_BC, param.PFIX_BC]
                field.u[i, j] = (height - param.y[j]) * param.y[j] / (height^2) * 6.0
            end
        end
    end

end

# =============================================================================
# backstep flow
# =============================================================================

struct Backstep <: AbstractFlow end


function initialize(
    param:: Parameter,
    field:: Field,
    flow:: Backstep
)
    cleanup!(param, field)
    set_bccode!(param, field, flow)
    set_code_ref!(param, field)
    set_init_condition!(param, field, flow)
end

function set_bccode!(
    param:: Parameter,
    field:: Field,
    flow:: Backstep
)
    field.bc_p[1, 2:param.n[2] - 1] .= param.VFIX_BC
    field.bc_p[2:param.n[1] - 1, 1] .= param.WALL_BC
    field.bc_p[2:param.n[1] - 1, param.n[2]] .= param.WALL_BC
    field.bc_p[param.n[1], 2:param.n[2] - 1] .= param.PFIX_BC

    nx = div(param.n[1], 5)
    ny = div(param.n[2], 3)
    field.bc_p[2:nx, 2:ny] .= param.WALL_BC
end

function set_init_condition!(
    param:: Parameter,
    field:: Field,
    flow:: Backstep
)
    ny = div(param.n[2], 3)
    field.u[1, (ny+1):end] .= 1.0
    field.u[2:end, 1:ny] .= 0.0
    field.v[:, :] .= 0.0
    field.p[:, :] .= 0.0

end

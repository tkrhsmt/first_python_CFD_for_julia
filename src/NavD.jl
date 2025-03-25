
function calc_div!(
    param:: Parameter,
    field:: Field
)
    cx = param.ρ / (param.Δt * param.Δx)
    cy = param.ρ / (param.Δt * param.Δy)

    for j in 1:param.n[2]
        for i in 1:param.n[1]
            if field.bc_p[i, j] == param.LIQUID
                tmp1 = (field.u[i, j] - field.u[i - 1, j]) * cx
                tmp2 = (field.v[i, j] - field.v[i, j - 1]) * cy
                field.∇u[i, j] = tmp1 + tmp2
            else
                field.∇u[i, j] = 0.0
            end
        end
    end
end

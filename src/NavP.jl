
function calc_p!(
    param:: Parameter,
    field:: Field
)

    field.Δp[:, :] .= 0.0

    rdx2 = 1.0 / (param.Δx^2)
    rdy2 = 1.0 / (param.Δy^2)
    coef = 1.0 / (- 2.0 * (rdx2 + rdy2))
    field.∇u[:, :] .*= coef

    solve_poisson!(
        param,
        field,
        rdx2,
        rdy2,
        coef
    )

    field.p[:, :] .+= field.Δp[:, :]

end

function solve_poisson!(
    param:: Parameter,
    field:: Field,
    rdx2:: Float64,
    rdy2:: Float64,
    coef:: Float64
)
    for roop in 1:50000
        δ = 0.0
        for j in 1:param.n[2]
            for i in 1:param.n[1]

                if field.bc_p[i, j] == param.LIQUID

                    tmp = - coef * (
                        (field.Δp[i + 1, j] + field.Δp[i - 1, j]) * rdx2 +
                        (field.Δp[i, j + 1] + field.Δp[i, j - 1]) * rdy2
                    ) + field.∇u[i, j]
                    if δ < abs(tmp - field.Δp[i, j])
                        δ = abs(tmp - field.Δp[i, j])
                    end
                    field.Δp[i, j] = tmp

                elseif field.bc_p[i, j] ∈ [param.WALL_BC, param.VFIX_BC]

                    tmp = field.ref_p[i, j]
                    field.Δp[i, j] = field.Δp[tmp[1], tmp[2]]

                elseif field.bc_p[i, j] == param.PFIX_BC

                    field.Δp[i, j] = 0.0

                end

            end
        end

        if δ < 1.0e-6
            break
        end
    end
end

function calc_pressure_term2!(
    param:: Parameter,
    field:: Field,
)
    coef = - param.Δt / param.ρ
    rdx = 1.0 / param.Δx
    rdy = 1.0 / param.Δy

    for j in 1:param.n[2]
        for i in 1:param.n[1]
            # x方向の圧力勾配
            if field.bc_u[i, j] == param.LIQUID
                field.Δu[i, j] = coef * rdx * (field.Δp[i + 1, j] - field.Δp[i, j])
            else
                field.Δu[i, j] = 0.0
            end

            # y方向の圧力勾配
            if field.bc_v[i, j] == param.LIQUID
                field.Δv[i, j] = coef * rdy * (field.Δp[i, j + 1] - field.Δp[i, j])
            else
                field.Δv[i, j] = 0.0
            end
        end
    end
end

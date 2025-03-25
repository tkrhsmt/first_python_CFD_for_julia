
function calc_pressure_term!(
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
                field.Δu[i, j] = coef * rdx * (field.p[i + 1, j] - field.p[i, j])
            else
                field.Δu[i, j] = 0.0
            end

            # y方向の圧力勾配
            if field.bc_v[i, j] == param.LIQUID
                field.Δv[i, j] = coef * rdy * (field.p[i, j + 1] - field.p[i, j])
            else
                field.Δv[i, j] = 0.0
            end
        end
    end
end

function check_stability(
    param:: Parameter,
    field:: Field,
)
    for j in 1:param.n[2]
        for i in 1:param.n[1]
            tmp1 = param.u[i, j] * param.Δt / param.Δx
            tmp2 = param.v[i, j] * param.Δt / param.Δx
            courant = maximum([tmp1, tmp2])
            if courant >= 0.5
                println("CFL条件を満たしていません")
                println("CFL値: $courant")
                exit(1)
            end
        end
    end

end

function add_convection!(
    param:: Parameter,
    field:: Field,
)
    coef = - param.Δt
    rdx = 1.0 / param.Δx
    rdy = 1.0 / param.Δy

    for j in 1:param.n[2]
        for i in 1:param.n[1]

            #x方向の速度
            if field.bc_u[i, j] == param.LIQUID
                vel_x = field.u[i, j]
                vel_y = 0.25 * (field.v[i, j] + field.v[i, j - 1] + field.v[i + 1, j] + field.v[i + 1, j - 1])

                if vel_x >= 0.0
                    field.Δu[i, j] += coef * rdx * vel_x * (field.u[i, j] - field.u[i - 1, j])
                else
                    field.Δu[i, j] += coef * rdx * vel_x * (field.u[i + 1, j] - field.u[i, j])
                end

                if vel_y >= 0.0
                    field.Δu[i, j] += coef * rdy * vel_y * (field.u[i, j] - field.u[i, j - 1])
                else
                    field.Δu[i, j] += coef * rdy * vel_y * (field.u[i, j + 1] - field.u[i, j])
                end
            end

            #y方向の速度
            if field.bc_v[i, j] == param.LIQUID
                vel_x = 0.25 * (field.u[i, j] + field.u[i - 1, j] + field.u[i, j + 1] + field.u[i - 1, j + 1])
                vel_y = field.v[i, j]

                if vel_x >= 0.0
                    field.Δv[i, j] += coef * rdx * vel_x * (field.v[i, j] - field.v[i - 1, j])
                else
                    field.Δv[i, j] += coef * rdx * vel_x * (field.v[i + 1, j] - field.v[i, j])
                end

                if vel_y >= 0.0
                    field.Δv[i, j] += coef * rdy * vel_y * (field.v[i, j] - field.v[i, j - 1])
                else
                    field.Δv[i, j] += coef * rdy * vel_y * (field.v[i, j + 1] - field.v[i, j])
                end
            end
        end
    end
end

function add_viscos_term!(
    param:: Parameter,
    field:: Field
)
    coef = param.ν * param.Δt
    rdx = 1.0 / (param.Δx^2)
    rdy = 1.0 / (param.Δy^2)

    for j in 1:param.n[2]
        for i in 1:param.n[1]
            if field.bc_u[i, j] == param.LIQUID
                tmp1 = rdx * (field.u[i + 1, j] - 2.0 * field.u[i, j] + field.u[i - 1, j])
                tmp2 = rdy * (field.u[i, j + 1] - 2.0 * field.u[i, j] + field.u[i, j - 1])
                field.Δu[i, j] += coef * (tmp1 + tmp2)
            end

            if field.bc_v[i, j] == param.LIQUID
                tmp1 = rdx * (field.v[i + 1, j] - 2.0 * field.v[i, j] + field.v[i - 1, j])
                tmp2 = rdy * (field.v[i, j + 1] - 2.0 * field.v[i, j] + field.v[i, j - 1])
                field.Δv[i, j] += coef * (tmp1 + tmp2)
            end
        end
    end
end

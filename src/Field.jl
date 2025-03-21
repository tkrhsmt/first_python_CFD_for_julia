
function get_center_u(
    nx :: Int64,
    ny :: Int64,
    field :: Field,
    scheme :: Scheme
)

    if scheme.interpolation == "first_order"
        return 0.5 * (field.u[nx, ny] + field.u[nx - 1, ny])
    end

end

function get_center_v(
    nx :: Int64,
    ny :: Int64,
    field :: Field,
    scheme :: Scheme
)

    if scheme.interpolation == "first_order"
        return 0.5 * (field.v[nx, ny] + field.v[nx, ny - 1])
    end

end

# ------------------------------

function set_code_ref!(
    param :: Parameter,
    field :: Field
)

    # 速度ノード境界を設定
    set_code_vel_u!(param, field)
    set_code_vel_v!(param, field)

    # 独立境界を設定
    set_isolated!(param, field)

    #参照を設定

end


function set_code_vel_u!(
    param :: Parameter,
    field :: Field
)

    for j in 1:param.n[2]
        for i in 1:param.n[1] - 1

            bc0 = field.bc_p[i, j]
            bc1 = field.bc_p[i + 1, j]

            # 両側の圧力が同じ境界条件の場合，その間の速度も同じ境界条件にする
            if bc0 == bc1
                field.bc_u[i, j] = bc0
            elseif bc0 == param.LIQUID || bc1 == param.LIQUID
                # 片側がLIQUIDでない場合，その境界を取得する
                NOT_LIQUID = bc0 + bc1 - param.LIQUID

                if NOT_LIQUID == param.WALL_BC
                    # その片側の境界が壁の場合，壁面境界にする
                    field.bc_u[i, j] = param.ONWALL_BC
                else
                    # その片側の境界が壁でない場合，それと同一境界にする
                    field.bc_u[i, j] = NOT_LIQUID
                end
            else
                # 両側が異なる境界で，かつどちらもLIQUIDでない場合，ISOLATEDにする
                field.bc_u[i, j] = param.ISOLATED_BC
            end

        end
    end

    field.bc_u[end, :] .= param.ISOLATED_BC

end

function set_code_vel_v!(
    param :: Parameter,
    field :: Field
)

    for j in 1:param.n[2] - 1
        for i in 1:param.n[1]

            bc0 = field.bc_p[i, j]
            bc1 = field.bc_p[i, j + 1]

            # 両側の圧力が同じ境界条件の場合，その間の速度も同じ境界条件にする
            if bc0 == bc1
                field.bc_v[i, j] = bc0
            elseif bc0 == param.LIQUID || bc1 == param.LIQUID
                # 片側がLIQUIDでない場合，その境界を取得する
                NOT_LIQUID = bc0 + bc1 - param.LIQUID

                if NOT_LIQUID == param.WALL_BC
                    # その片側の境界が壁の場合，壁面境界にする
                    field.bc_v[i, j] = param.ONWALL_BC
                else
                    # その片側の境界が壁でない場合，それと同一境界にする
                    field.bc_v[i, j] = NOT_LIQUID
                end
            else
                # 両側が異なる境界で，かつどちらもLIQUIDでない場合，ISOLATEDにする
                field.bc_v[i, j] = param.ISOLATED_BC
            end

        end
    end

    field.bc_v[:, end] .= param.ISOLATED_BC

end

function set_isolated!(
    param :: Parameter,
    field :: Field
)

    for j in 2:param.n[2] - 1
        for i in 2:param.n[1] - 1

            tmp = !(
                field.bc_p[i, j - 1] == param.LIQUID ||
                field.bc_p[i + 1, j - 1] == param.LIQUID ||
                field.bc_p[i, j] == param.LIQUID ||
                field.bc_p[i + 1, j] == param.LIQUID ||
                field.bc_p[i, j + 1] == param.LIQUID ||
                field.bc_p[i + 1, j + 1] == param.LIQUID
            )
            if tmp
                field.bc_u[i, j] = param.ISOLATED_BC
            end

            tmp = !(
                field.bc_p[i - 1, j] == param.LIQUID ||
                field.bc_p[i - 1, j + 1] == param.LIQUID ||
                field.bc_p[i, j] == param.LIQUID ||
                field.bc_p[i, j + 1] == param.LIQUID ||
                field.bc_p[i + 1, j] == param.LIQUID ||
                field.bc_p[i + 1, j + 1] == param.LIQUID
            )
            if tmp
                field.bc_v[i, j] = param.ISOLATED_BC
            end

        end
    end

end

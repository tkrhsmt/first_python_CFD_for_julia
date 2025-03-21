
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

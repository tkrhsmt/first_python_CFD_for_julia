
function smac(
    param::Parameter,
    field::Field,
)

    check_stability(param, field)

    calc_pressure_term!(param, field)
    add_viscos_term!(param, field)
    add_convection!(param, field)
    modify_velocity!(param, field)

    calc_div!(param, field)
    calc_p!(param, field)

    calc_pressure_term2!(param, field)
    modify_velocity!(param, field)
end

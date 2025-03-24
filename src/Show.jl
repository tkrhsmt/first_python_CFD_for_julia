
function array_rank(ϕ, message :: String, param:: Parameter)

    fmaxx = maximum(ϕ)
    fminn = minimum(ϕ)
    if fmaxx == fminn
        fmaxx = fmaxx + 1.0
    end

    array_min_max(ϕ, message, fminn, fmaxx, param)
end

function array_min_max(ϕ, message :: String, fminn, fmaxx, param:: Parameter)

    println("--------------------------------------------------")
    println(message)
    println("max: $(fmaxx)")
    println("min: $(fminn)")
    println("- - - - - - - - - -")

    buf = fill("", param.n[1])
    mem = []

    for j in 1:param.n[2]
        for i in 1:param.n[1]
            fv = ϕ[i, j] * 1.0
            a = (fv - fminn) / (fmaxx - fminn)
            ia = Int(floor(a * 9.9999))

            if 0 <= ia <= 9
                buf[i] = string(ia)
            elseif ia > 9
                buf[i] = "+"
            else
                buf[i] = "-"
            end

        end

        b = join(buf, "")
        println("$j:\t$b")
        push!(mem, b)
    end

    println("--------------------------------------------------")

    return mem
end

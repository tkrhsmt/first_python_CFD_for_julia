
struct Parameter

    # --- 固定定数 --- #
    #流体
    LIQUID :: Int64
    #圧力固定境界
    PFIX_BC :: Int64
    #速度固定境界
    VFIX_BC :: Int64
    #壁面滑りなし境界
    WALL_BC :: Int64
    #壁面滑りあり境界
    ONWALL_BC :: Int64
    #周期境界
    ISOLATED_BC :: Int64

    # --- 流れ場定数 --- #

    n :: Tuple{Int64, Int64}

    L :: Tuple{Float64, Float64}

    ρ :: Float64
    ν :: Float64

    Δt :: Float64
    Δx :: Float64
    Δy :: Float64

    function Parameter(
        nx :: Int64,
        ny :: Int64,
        Lx :: Float64,
        Ly :: Float64,
        ρ  :: Float64,
        μ  :: Float64,
        Δt :: Float64
    )

        LIQUID = 0
        PFIX_BC = 1
        VFIX_BC = 2
        WALL_BC = 3
        ONWALL_BC = 4
        ISOLATED_BC = 9

        n = (nx, ny)
        L = (Lx, Ly)

        ν = μ / ρ

        Δx = Lx / nx
        Δy = Ly / ny

        println("--------------------------------------------------")
        println("                     流体定数")
        println("LIQUID: $LIQUID")
        println("PFIX_BC: $PFIX_BC")
        println("VFIX_BC: $VFIX_BC")
        println("WALL_BC: $WALL_BC")
        println("ONWALL_BC: $ONWALL_BC")
        println("ISOLATED_BC: $ISOLATED_BC")
        println("--------------------------------------------------")
        println("                    流れ場定数")
        println("n: $n")
        println("L: $L")
        println("ρ: $ρ")
        println("ν: $ν")
        println("Δt: $Δt")
        println("Δx: $Δx")
        println("Δy: $Δy")
        println("--------------------------------------------------")

        return new(LIQUID, PFIX_BC, VFIX_BC, WALL_BC, ONWALL_BC, ISOLATED_BC, n, L, ρ, ν, Δt, Δx, Δy)
    end

end

struct Field

    u :: Array{Float64, 2}
    v :: Array{Float64, 2}
    p :: Array{Float64, 2}

    bc_u :: Array{Int64, 2}
    bc_v :: Array{Int64, 2}
    bc_p :: Array{Int64, 2}

    function Field(param :: Parameter)

        u = zeros(Float64, param.n[1] + 1, param.n[2])
        v = zeros(Float64, param.n[1], param.n[2] + 1)
        p = zeros(Float64, param.n[1], param.n[2])

        bc_u = zeros(Int64, param.n[1] + 1, param.n[2])
        bc_v = zeros(Int64, param.n[1], param.n[2] + 1)
        bc_p = zeros(Int64, param.n[1], param.n[2])

        return new(u, v, p, bc_u, bc_v, bc_p)
    end
end

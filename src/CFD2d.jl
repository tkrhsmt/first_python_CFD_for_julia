module CFD2d

# パラメータの設定
include("Parameter.jl")

# 流れ場の設定
include("Field.jl")

# 流れ場の可視化
include("Visu.jl")

end

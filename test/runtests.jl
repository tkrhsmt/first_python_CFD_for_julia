using CFD2d
using Test

@testset "setting" begin
    include("setting.jl")
end

@testset "show" begin
    include("show.jl")
end

@testset "setup" begin
    include("setup.jl")
end

@testset "navpress" begin
    include("navpress.jl")
end

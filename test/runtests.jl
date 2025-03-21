using CFD2d
using Test
using PrettyTables

@testset "setting" begin
    # Write your tests here.
    include("setting.jl")
end

@testset "Field" begin
    # Write your tests here.
    include("field.jl")
end

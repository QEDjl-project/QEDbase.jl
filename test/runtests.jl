using QEDbase
using Test
using SafeTestsets

begin
    # # Interfaces
    @time @safetestset "model interface" begin
        include("interfaces/model.jl")
    end

    @time @safetestset "process interface" begin
        include("interfaces/process.jl")
    end

    @time @safetestset "computation setup interface" begin
        include("interfaces/setup.jl")
    end

    @time @safetestset "Lorentz interface" begin
        include("lorentz_interface.jl")
    end

    @time @safetestset "Dirac tensors" begin
        include("dirac_tensor.jl")
    end

    @time @safetestset "Lorentz Vectors" begin
        include("lorentz_vector.jl")
    end

    @time @safetestset "particle spinors" begin
        include("particle_spinors.jl")
    end

    @time @safetestset "particles" begin
        include("particles.jl")
    end
end

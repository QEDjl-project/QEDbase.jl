using QEDbase
using Test
using SafeTestsets

begin
    @time @safetestset "Dirac tensors" begin
        include("dirac_tensor.jl")
    end

    @time @safetestset "Lorentz Vectors" begin
        include("lorentz_vector.jl")
    end
  
    @time @safetestset "Lorentz interface" begin
        include("lorentz_interface.jl")
    end
    @time @safetestset "Gamma matrices" begin
        include("gamma_matrices.jl")
    end

    @time @safetestset "particle spinors" begin
        include("particle_spinors.jl")
    end

    @time @safetestset "four momentum" begin
        include("four_momentum.jl")
    end

    @time @safetestset "particles" begin
        include("particles.jl")
    end
end

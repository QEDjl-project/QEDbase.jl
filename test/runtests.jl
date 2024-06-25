using QEDbase
using Test
using SafeTestsets

begin
    # Interfaces
    @time @safetestset "model interface" begin
        include("interfaces/model.jl")
    end

    @time @safetestset "Lorentz interface" begin
        include("interfaces/lorentz.jl")
    end

    @time @safetestset "particles" begin
        include("particle_properties.jl")
    end

    @time @safetestset "QEDcore: Lorentz vector" begin
        include("core_compat/lorentz_vector.jl")
    end

    @time @safetestset "QEDcore: FourMomentum" begin
        include("core_compat/four_momentum.jl")
    end
end

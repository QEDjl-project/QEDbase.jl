using Test
using SafeTestsets

begin
    # Interfaces
    @time @safetestset "coordinate transforms" begin
        include("interfaces/coordinate_transforms.jl")
    end

    @time @safetestset "model interface" begin
        include("interfaces/model.jl")
    end

    @time @safetestset "process interface" begin
        include("interfaces/process.jl")
    end

    @time @safetestset "phase space point interface" begin
        include("interfaces/phase_space_point.jl")
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

    @time @safetestset "cross sections" begin
        include("cross_sections.jl")
    end
end

begin
    @time @safetestset "GPU testing" begin
        include("gpu_tests/gpu.jl")
    end
end

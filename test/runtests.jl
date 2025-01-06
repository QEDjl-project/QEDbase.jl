using Test
using SafeTestsets

include("test_implementation/TestImplementation.jl")
# check if we run CPU tests (yes by default)
cpu_tests = tryparse(Bool, get(ENV, "TEST_CPU", "1"))

if cpu_tests
    # Interfaces
    #=
    @time @safetestset "momentum interface" begin
        include("interfaces/momentum.jl")
    end

    @time @safetestset "coordinate transforms" begin
        include("interfaces/coordinate_transforms.jl")
    end
    =#
    @time @safetestset "particles" begin
        include("interfaces/particles.jl")
    end
    #=
        @time @safetestset "particles properties" begin
            include("particle_properties.jl")
        end

        @time @safetestset "model interface" begin
            include("interfaces/model.jl")
        end

        @time @safetestset "process interface" begin
            include("interfaces/process.jl")
        end

        @time @safetestset "phase space layout" begin
            include("interfaces/phase_space_layout.jl")
        end

        @time @safetestset "phase space point interface" begin
            include("interfaces/phase_space_point.jl")
        end

        @time @safetestset "cross sections" begin
            include("cross_sections.jl")
        end

        =#

    # TODO: move to QEDcore!
    #=
    @time @safetestset "QEDcore: Lorentz vector" begin
        include("core_compat/lorentz_vector.jl")
    end

    @time @safetestset "QEDcore: FourMomentum" begin
        include("core_compat/four_momentum.jl")
    end
    =#

else
    @info "Skipping CPU tests"
end

begin
    @time @safetestset "GPU testing" begin
        include("gpu/runtests.jl")
    end
end

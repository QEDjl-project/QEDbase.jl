using Test
using SafeTestsets

include("utils.jl")

# check if we run CPU tests (yes by default)
cpu_tests = _is_test_platform_active(["CI_QED_TEST_CPU", "TEST_CPU"], true)

if cpu_tests
    # Interface
    @time @safetestset "momentum interface" begin
        include("interfaces/momentum.jl")
    end

    @time @safetestset "coordinate transforms" begin
        include("interfaces/coordinate_transforms.jl")
    end

    @time @safetestset "particles" begin
        include("interfaces/particles.jl")
    end

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

else
    @info "Skipping CPU tests"
end

begin
    @time @safetestset "GPU testing" begin
        include("gpu/runtests.jl")
    end
end

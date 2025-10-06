"""
This file sets up GPU testing. By default, it will check if GPU libraries are installed and
functional, and execute the unit tests then. Additionally, if an environment variable is set
("TEST_<GPU> = 1"), the tests will fail if the library is not functional.
"""

include("../utils.jl")

GPUS = Vector{Tuple{Module, Type}}()
GPU_FLOAT_TYPES = Dict{Module, Vector{Type}}()

# check if we test with AMDGPU
amdgpu_tests = _is_test_platform_active(["CI_QED_TEST_AMDGPU", "TEST_AMDGPU"], false)
if amdgpu_tests
    try
        using Pkg
        Pkg.add("AMDGPU")

        using AMDGPU
        AMDGPU.functional() || throw(
            "trying to test with AMDGPU.jl but it is not functional (AMDGPU.functional() == false)",
        )
        push!(GPUS, (AMDGPU, ROCVector))
        GPU_FLOAT_TYPES[AMDGPU] = [Float32, Float64]
        @info "Testing with AMDGPU.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with CUDA
cuda_tests = _is_test_platform_active(["CI_QED_TEST_CUDA", "TEST_CUDA"], false)
if cuda_tests
    try
        using Pkg
        Pkg.add("CUDA")

        using CUDA
        CUDA.functional() || throw(
            "trying to test with CUDA.jl but it is not functional (CUDA.functional() == false)",
        )
        push!(GPUS, (CUDA, CuVector))
        GPU_FLOAT_TYPES[CUDA] = [Float32, Float64]
        @info "Testing with CUDA.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with oneAPI
oneapi_tests = _is_test_platform_active(["CI_QED_TEST_ONEAPI", "TEST_ONEAPI"], false)
if oneapi_tests
    try
        using Pkg
        Pkg.add("oneAPI")

        using oneAPI
        oneAPI.functional() || throw(
            "trying to test with oneAPI.jl but it is not functional (oneAPI.functional() == false)",
        )
        push!(GPUS, (oneAPI, oneVector))
        GPU_FLOAT_TYPES[oneAPI] = [Float32]
        if oneL0.module_properties(device()).fp64flags & oneL0.ZE_DEVICE_MODULE_FLAG_FP64 ==
                oneL0.ZE_DEVICE_MODULE_FLAG_FP64
            # This checks whether the Intel GPU supports Float64, see oneAPI Readme
            push!(GPU_FLOAT_TYPES[oneAPI], Float64)
        end
        @info "Testing with oneAPI.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with Metal
metal_tests = _is_test_platform_active(["CI_QED_TEST_METAL", "TEST_METAL"], false)
if metal_tests
    try
        using Pkg
        Pkg.add("Metal")

        using Metal
        Metal.functional() || throw(
            "trying to test with Metal.jl but it is not functional (Metal.functional() == false)",
        )
        push!(GPUS, (Metal, MtlVector))
        GPU_FLOAT_TYPES[Metal] = [Float32]
        @info "Testing with Metal.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

#include("../test_implementation/TestImplementation.jl")

# from here on, we cannot use safe test sets or we would unload the GPU libraries again
include("momentum_map.jl")

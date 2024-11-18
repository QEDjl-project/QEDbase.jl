"""
This file sets up GPU testing. By default, it will check if GPU libraries are installed and
functional, and execute the unit tests then. Additionally, if an environment variable is set
("TEST_<GPU> = 1"), the tests will fail if the library is not functional.
"""

GPU_VECTOR_TYPES = Vector{Type}()

# check if we test with AMDGPU
amdgpu_tests = tryparse(Bool, get(ENV, "TEST_AMDGPU", "0"))
if amdgpu_tests
    try
        using Pkg
        Pkg.add("AMDGPU")

        using AMDGPU
        AMDGPU.functional() || throw(
            "trying to test with AMDGPU.jl but it is not functional (AMDGPU.functional() == false)",
        )
        push!(GPU_VECTOR_TYPES, ROCVector)
        @info "Testing with AMDGPU.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with CUDA
cuda_tests = tryparse(Bool, get(ENV, "TEST_CUDA", "0"))
if cuda_tests
    try
        using Pkg
        Pkg.add("CUDA")

        using CUDA
        CUDA.functional() || throw(
            "trying to test with CUDA.jl but it is not functional (CUDA.functional() == false)",
        )
        push!(GPU_VECTOR_TYPES, CuVector)
        @info "Testing with CUDA.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with oneAPI
oneapi_tests = tryparse(Bool, get(ENV, "TEST_ONEAPI", "0"))
if oneapi_tests
    try
        using Pkg
        Pkg.add("oneAPI")

        using oneAPI
        oneAPI.functional() || throw(
            "trying to test with oneAPI.jl but it is not functional (oneAPI.functional() == false)",
        )
        push!(GPU_VECTOR_TYPES, oneVector)
        @info "Testing with oneAPI.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with Metal
metal_tests = tryparse(Bool, get(ENV, "TEST_METAL", "0"))
if metal_tests
    try
        using Pkg
        Pkg.add("Metal")

        using Metal
        Metal.functional() || throw(
            "trying to test with Metal.jl but it is not functional (Metal.functional() == false)",
        )
        push!(GPU_VECTOR_TYPES, MtlVector)
        @info "Testing with Metal.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

include("unit_tests.jl")

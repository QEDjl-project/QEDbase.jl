"""
This file sets up GPU testing. By default, it will check if GPU libraries are installed and
functional, and execute the unit tests then. Additionally, if an environment variable is set
("FORCE_<GPU> = 1"), the tests will fail if the library is not functional.
"""

GPU_VECTOR_TYPES = Vector{Type}()

# check if we test with AMDGPU
amdgpu_tests = get(ENV, "FORCE_AMDGPU", false)
if amdgpu_tests
    try
        using Pkg
        Pkg.add("AMDGPU")

        using AMDGPU
        AMDGPU.functional() || throw("AMDGPU.jl is not functional")
        push!(GPU_VECTOR_TYPES, ROCVector)
        @info "Testing with AMDGPU.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

# check if we test with CUDA
cuda_tests = get(ENV, "FORCE_CUDA", false)
if cuda_tests
    try
        using Pkg
        Pkg.add("CUDA")

        using CUDA
        CUDA.functional() || throw("CUDA.jl is not functional")
        push!(GPU_VECTOR_TYPES, CuVector)
        @info "Testing with CUDA.jl"
    catch e
        @error "failed to run GPU tests, make sure the required libraries are installed\n$(e)"
        @test false
    end
end

include("unit_tests.jl")

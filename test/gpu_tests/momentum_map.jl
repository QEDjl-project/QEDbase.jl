if isempty(GPU_VECTOR_TYPES)
    @info """No functional GPUs found for testing, skipping tests...
    To test GPU functionality, please use 'TEST_<GPU> = 1 julia ...' for one of GPU=[CUDA, AMDGPU, METAL, ONEAPI]"""
    return nothing
end

@testset "Testing with $VECTOR_TYPE" for VECTOR_TYPE in GPU_VECTOR_TYPES
    @testset "momentum map" begin
        @test true
    end
end

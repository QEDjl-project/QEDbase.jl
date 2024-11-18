if isempty(GPU_VECTOR_TYPES)
    @info "No functional GPUs found for testing, skipping tests..."
    return nothing
end

@testset "Testing with $VECTOR_TYPE" for VECTOR_TYPE in GPU_VECTOR_TYPES
    @testset "momentum map" begin
        @test true
    end
end

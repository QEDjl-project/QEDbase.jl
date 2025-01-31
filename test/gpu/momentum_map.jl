if isempty(GPUS)
    @info """No GPU tests are enabled, skipping tests...
    To test GPU functionality, please use 'TEST_<GPU> = 1 julia ...' for one of GPU=[CUDA, AMDGPU, METAL, ONEAPI]"""
    return nothing
end

using Random
using QEDbase
using QEDbase.Mocks

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

MOM_TYPE = MockMomentum{Float64}

TESTMODEL = MockModel()
TESTPSDEF = MockPhasespaceDef{MOM_TYPE}()
TESTTRAFO = MockCoordinateTrafo()

@testset "Testing with $GPU_MODULE" for (GPU_MODULE, VECTOR_TYPE) in GPUS
    @testset "momentum map" begin
        @testset "momenta" begin
            test_moms = [MOM_TYPE(rand(RNG, 4)) for _ in 1:100]
            gpu_moms = VECTOR_TYPE(test_moms)

            test_moms_prime = TESTTRAFO.(test_moms)
            gpu_moms_prime = TESTTRAFO.(gpu_moms)

            @test isapprox(test_moms_prime, Vector(gpu_moms_prime))
        end
    end

    @testset "phase space points" begin
        @testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in
                                                 Iterators.product(
            (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
        )
            INCOMING_PARTICLES = Tuple(rand(RNG, Mocks.PARTICLE_SET, N_INCOMING))
            OUTGOING_PARTICLES = Tuple(rand(RNG, Mocks.PARTICLE_SET, N_OUTGOING))

            TESTPROC = MockProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)

            test_psps = [
                MockPhaseSpacePoint(
                    TESTPROC,
                    TESTMODEL,
                    TESTPSDEF,
                    Mocks._rand_momenta(RNG, N_INCOMING, MOM_TYPE),
                    Mocks._rand_momenta(RNG, N_OUTGOING, MOM_TYPE),
                ) for _ in 1:100
            ]
            gpu_test_psps = VECTOR_TYPE(test_psps)

            test_psps_prime = TESTTRAFO.(test_psps)
            gpu_test_psps_prime = TESTTRAFO.(gpu_test_psps)

            @test all(isapprox.(test_psps_prime, Vector(gpu_test_psps_prime)))
        end
    end
end

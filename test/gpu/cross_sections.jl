# file to test the KernelAbstractions interfaces for cross sections and probabilities
using Random
using QEDbase
using QEDbase.Mocks

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

TESTMODEL = MockModel()

N = 128

@testset "Testing with $GPU_MODULE" for (GPU_MODULE, VECTOR_TYPE) in GPUS
    @testset "testing with $FLOAT_T" for FLOAT_T in GPU_FLOAT_TYPES[GPU_MODULE]
        INCOMING_PARTICLES = Tuple(rand(RNG, Mocks.PARTICLE_SET, 2))
        OUTGOING_PARTICLES = Tuple(rand(RNG, Mocks.PARTICLE_SET, 2))

        TESTPROC = MockProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)
        MOM_TYPE = MockMomentum{FLOAT_T}
        TESTPSL = MockOutPhaseSpaceLayout(MOM_TYPE)

        p_in = [Mocks._rand_momenta(RNG, 2, MOM_TYPE) for _ in 1:N]
        p_out = [Mocks._rand_momenta(RNG, 2, MOM_TYPE) for _ in 1:N]

        psps = MockPhaseSpacePoint.(TESTPROC, TESTMODEL, Ref(TESTPSL), p_in, p_out)
        gpupsps = VECTOR_TYPE(psps)

        @testset "KernelAbstractions cross section" begin
            dest = similar(gpupsps, FLOAT_T)
            gt = unsafe_differential_cross_section.(psps)
            unsafe_differential_cross_section!(dest, gpupsps)
            @test sum(isapprox.(Vector(dest), gt)) == N

            fill!(dest, zero(FLOAT_T))
            gt = differential_cross_section.(psps)
            differential_cross_section!(dest, gpupsps)
            @test sum(isapprox.(Vector(dest), gt)) == N
        end

        @testset "KernelAbstractions probability" begin
            dest = similar(gpupsps, FLOAT_T)
            gt = unsafe_differential_probability.(psps)
            unsafe_differential_probability!(dest, gpupsps)
            @test sum(isapprox.(Vector(dest), gt)) == N

            fill!(dest, zero(FLOAT_T))
            gt = differential_probability.(psps)
            differential_probability!(dest, gpupsps)
            @test sum(isapprox.(Vector(dest), gt)) == N
        end
    end
end

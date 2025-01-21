using Random
using QEDbase

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("../test_implementation/TestImplementation.jl")
using .TestImplementation

TESTMODEL = TestModel()

@testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float16, Float32, Float64)
    MOM_TYPE = TestMomentum{MOM_EL_TYPE}
    TESTPSL = TestOutPhaseSpaceLayout(MOM_TYPE)

    TESTTRAFO = TestCoordinateTrafo()

    @testset "broadcast" begin
        test_func(trafo) = trafo
        @test test_func.(TESTTRAFO) == TESTTRAFO
    end

    @testset "single momenta" begin
        test_mom = MOM_TYPE(rand(RNG, 4))

        test_mom_prime = @inferred TESTTRAFO(test_mom)

        @test isapprox(
            test_mom_prime, TestImplementation._groundtruth_coord_trafo(test_mom)
        )
    end

    @testset "set of momenta" begin
        test_moms = [MOM_TYPE(rand(RNG, 4)) for _ in 1:3]
        test_moms_prime = TESTTRAFO.(test_moms)

        @test isapprox(
            test_moms_prime, TestImplementation._groundtruth_coord_trafo.(test_moms)
        )
    end

    @testset "phase space points" begin
        @testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in
                                                 Iterators.product(
            (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
        )
            INCOMING_PARTICLES = Tuple(
                rand(RNG, TestImplementation.PARTICLE_SET, N_INCOMING)
            )
            OUTGOING_PARTICLES = Tuple(
                rand(RNG, TestImplementation.PARTICLE_SET, N_OUTGOING)
            )

            TESTPROC = TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)

            p_in_phys = TestImplementation._rand_momenta(RNG, N_INCOMING, MOM_TYPE)
            p_out_phys = TestImplementation._rand_momenta(RNG, N_OUTGOING, MOM_TYPE)

            PS_POINT = TestPhaseSpacePoint(
                TESTPROC, TESTMODEL, TESTPSL, p_in_phys, p_out_phys
            )

            test_psp_prime = TESTTRAFO(PS_POINT)

            @test test_psp_prime == TestImplementation._groundtruth_coord_trafo(PS_POINT)
        end
    end
end

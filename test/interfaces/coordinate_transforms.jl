using Random
using QEDbase
using QEDbase.Mocks

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

TESTMODEL = MockModel()

@testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float16, Float32, Float64)
    MOM_TYPE = MockMomentum{MOM_EL_TYPE}
    TESTPSDEF = MockPhasespaceDef{MOM_TYPE}()

    TESTTRAFO = MockCoordinateTrafo()

    @testset "broadcast" begin
        test_func(trafo) = trafo
        @test test_func.(TESTTRAFO) == TESTTRAFO
    end

    @testset "single momenta" begin
        test_mom = MOM_TYPE(rand(RNG, 4))

        test_mom_prime = @inferred TESTTRAFO(test_mom)

        @test isapprox(test_mom_prime, Mocks._groundtruth_coord_trafo(test_mom))
    end

    @testset "set of momenta" begin
        test_moms = [MOM_TYPE(rand(RNG, 4)) for _ in 1:3]
        test_moms_prime = TESTTRAFO.(test_moms)

        @test isapprox(test_moms_prime, Mocks._groundtruth_coord_trafo.(test_moms))
    end

    @testset "phase space points" begin
        @testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in
                                                 Iterators.product(
            (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
        )
            INCOMING_PARTICLES = Tuple(rand(RNG, Mocks.PARTICLE_SET, N_INCOMING))
            OUTGOING_PARTICLES = Tuple(rand(RNG, Mocks.PARTICLE_SET, N_OUTGOING))

            TESTPROC = MockProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)

            p_in_phys = Mocks._rand_momenta(RNG, N_INCOMING, MOM_TYPE)
            p_out_phys = Mocks._rand_momenta(RNG, N_OUTGOING, MOM_TYPE)

            PS_POINT = MockPhaseSpacePoint(
                TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
            )

            test_psp_prime = TESTTRAFO(PS_POINT)

            @test test_psp_prime == Mocks._groundtruth_coord_trafo(PS_POINT)
        end
    end
end

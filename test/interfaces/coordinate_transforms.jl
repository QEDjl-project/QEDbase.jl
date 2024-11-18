using Random
using QEDbase
using QEDcore

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("../test_implementation/TestImplementation.jl")
TESTMODEL = TestImplementation.TestModel()
TESTPSDEF = TestImplementation.TestPhasespaceDef()

TESTTRAFO = TestImplementation.TestCoordTrafo()

@testset "broadcast" begin
    test_func(trafo) = trafo
    @test test_func.(TESTTRAFO) == TESTTRAFO
end

@testset "single momenta" begin
    test_mom = rand(RNG, SFourMomentum)

    test_mom_prime = @inferred TESTTRAFO(test_mom)

    @test isapprox(test_mom_prime, TestImplementation._groundtruth_coord_trafo(test_mom))
end

@testset "set of momenta" begin
    test_moms = rand(RNG, SFourMomentum, 3)
    test_moms_prime = TESTTRAFO.(test_moms)

    @test isapprox(test_moms_prime, TestImplementation._groundtruth_coord_trafo.(test_moms))
end

@testset "phase space points" begin
    @testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in Iterators.product(
        (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
    )
        INCOMING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_INCOMING))
        OUTGOING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_OUTGOING))

        TESTPROC = TestImplementation.TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)

        p_in_phys = TestImplementation._rand_momenta(RNG, N_INCOMING)
        p_out_phys = TestImplementation._rand_momenta(RNG, N_OUTGOING)

        PS_POINT = PhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys)

        test_psp_prime = @inferred TESTTRAFO(PS_POINT)

        @test test_psp_prime == TestImplementation._groundtruth_coord_trafo(PS_POINT)
    end
end

using Random
using QEDbase

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("test_implementation/TestImplementation.jl")
using .TestImplementation

MOM_TYPE = TestMomentum{Float64}
TESTMODEL = TestModel()
TESTPSDEF = TestPhasespaceDef{MOM_TYPE}()

@testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in Iterators.product(
    (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
)
    INCOMING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_INCOMING))
    OUTGOING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_OUTGOING))

    TESTPROC = TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)

    # single ps points
    p_in_phys = TestImplementation._rand_momenta(RNG, N_INCOMING, MOM_TYPE)
    p_in_phys_invalid = TestImplementation._rand_momenta(RNG, N_INCOMING + 1, MOM_TYPE)
    p_in_unphys = TestImplementation._rand_in_momenta_failing(RNG, N_INCOMING, MOM_TYPE)

    p_out_phys = TestImplementation._rand_momenta(RNG, N_OUTGOING, MOM_TYPE)
    p_out_unphys = TestImplementation._rand_out_momenta_failing(RNG, N_OUTGOING, MOM_TYPE)

    p_in_all = (p_in_phys, p_in_unphys)

    p_out_all = (p_out_phys, p_out_unphys)

    # all combinations
    p_combs = Iterators.product(p_in_all, p_out_all)

    @testset "differential cross section" begin
        @testset "unsafe compute" begin
            PS_POINT = TestPhaseSpacePoint(
                TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
            )

            diffCS_on_psp = unsafe_differential_cross_section(PS_POINT)
            groundtruth = TestImplementation._groundtruth_unsafe_diffCS(
                TESTPROC, p_in_phys, p_out_phys
            )

            @test isapprox(diffCS_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
        end

        @testset "safe compute" begin
            for (P_IN, P_OUT) in p_combs
                PS_POINT = TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, P_IN, P_OUT)

                diffCS_on_psp = differential_cross_section(PS_POINT)
                groundtruth = TestImplementation._groundtruth_safe_diffCS(
                    TESTPROC, P_IN, P_OUT
                )

                @test isapprox(diffCS_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
            end
        end
    end

    @testset "total cross section" begin
        @testset "compute" begin
            #COORDS_IN = TestImplementation.flat_components(p_in_phys)

            IN_PS_POINT = TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, ())
            #IN_PS_POINT_COORDS = TestPhaseSpacePoint(
            #    TESTPROC, TESTMODEL, TESTPSDEF, COORDS_IN, ()
            #)

            groundtruth = TestImplementation._groundtruth_total_cross_section(p_in_phys)
            totCS_on_moms = total_cross_section(IN_PS_POINT)
            #totCS_on_coords = total_cross_section(IN_PS_POINT_COORDS)

            @test isapprox(totCS_on_moms, groundtruth, atol=ATOL, rtol=RTOL)
            #@test isapprox(totCS_on_coords, groundtruth, atol=ATOL, rtol=RTOL)
        end
    end

    @testset "differential probability" begin
        @testset "unsafe compute" begin
            PS_POINT = TestPhaseSpacePoint(
                TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
            )
            prop_on_psp = unsafe_differential_probability(PS_POINT)
            groundtruth = TestImplementation._groundtruth_unsafe_probability(
                TESTPROC, p_in_phys, p_out_phys
            )
            @test isapprox(prop_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
        end

        @testset "safe compute" begin
            for (P_IN, P_OUT) in p_combs
                PS_POINT = TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, P_IN, P_OUT)
                prop_on_psp = differential_probability(PS_POINT)
                groundtruth = TestImplementation._groundtruth_safe_probability(
                    TESTPROC, P_IN, P_OUT
                )
                @test isapprox(prop_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
            end
        end
    end

    @testset "total probability" begin
        @testset "compute" begin
            #COORDS_IN = TestImplementation.flat_components(p_in_phys)

            IN_PS_POINT = TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, ())
            #IN_PS_POINT_COORDS = TestPhaseSpacePoint(
            #   TESTPROC, TESTMODEL, TESTPSDEF, COORDS_IN, ()
            #)

            groundtruth = TestImplementation._groundtruth_total_probability(p_in_phys)
            totCS_on_moms = TestImplementation.total_probability(IN_PS_POINT)
            #totCS_on_coords = TestImplementation.total_probability(IN_PS_POINT_COORDS)

            @test isapprox(totCS_on_moms, groundtruth, atol=ATOL, rtol=RTOL)
            #@test isapprox(totCS_on_coords, groundtruth, atol=ATOL, rtol=RTOL)
        end
    end
end

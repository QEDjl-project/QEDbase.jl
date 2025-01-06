using Random
using QEDbase

RNG = MersenneTwister(137137)

include("../test_implementation/TestImplementation.jl")
using .TestImplementation

@testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in Iterators.product(
    (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
)
    @testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float16, Float32, Float64)
        ATOL = 0.0
        RTOL = sqrt(eps(MOM_EL_TYPE))
        MOM_TYPE = TestMomentum{MOM_EL_TYPE}
        INCOMING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_INCOMING))
        OUTGOING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_OUTGOING))

        TESTPROC = TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)
        TESTMODEL = TestModel()

        TESTINPSL = TestInPhaseSpaceLayout{MOM_TYPE}()
        TESTINCOORDS = Tuple(rand(RNG, 4 * N_INCOMING))
        test_in_moms = @inferred build_momenta(TESTPROC, TESTMODEL, TESTINPSL, TESTINCOORDS)
        groundtruth_in_moms = TestImplementation._groundtruth_in_moms(
            TESTINCOORDS, MOM_TYPE
        )

        TESTOUTPSL = TestOutPhaseSpaceLayout(TESTINPSL)
        TESTOUTCOORDS = Tuple(rand(RNG, 4 * N_OUTGOING - 4))
        test_out_moms = @inferred build_momenta(
            TESTPROC, TESTMODEL, test_in_moms, TESTOUTPSL, TESTOUTCOORDS
        )
        groundtruth_out_moms = TestImplementation._groundtruth_out_moms(
            test_in_moms, TESTOUTCOORDS, MOM_TYPE
        )

        @testset "build momenta" begin
            @testset "in-phase-space layout" begin
                @test length(test_in_moms) == N_INCOMING
                @test all(
                    isapprox.(test_in_moms, groundtruth_in_moms, atol=ATOL, rtol=RTOL)
                )
            end

            @testset "out-phase-space layout" begin
                @test length(test_out_moms) == N_OUTGOING
                @test all(
                    isapprox.(test_out_moms, groundtruth_out_moms, atol=ATOL, rtol=RTOL)
                )
                @test isapprox(sum(test_in_moms), sum(test_out_moms), atol=ATOL, rtol=RTOL)
            end

            @testset "Error handling" begin

                # not enough coordinates
                @test_throws InvalidInputError build_momenta(
                    TESTPROC, TESTMODEL, TESTINPSL, TESTINCOORDS[2:end]
                )

                # too much coordinates
                @test_throws InvalidInputError build_momenta(
                    TESTPROC, TESTMODEL, TESTINPSL, (TESTINCOORDS..., rand(RNG))
                )

                # "no coordinates" is already the lowest amount
                if N_OUTGOING != 1
                    # not enough coordinates
                    @test_throws InvalidInputError build_momenta(
                        TESTPROC, TESTMODEL, test_in_moms, TESTOUTPSL, TESTOUTCOORDS[2:end]
                    )
                end

                # too many coordinates
                @test_throws InvalidInputError build_momenta(
                    TESTPROC,
                    TESTMODEL,
                    test_in_moms,
                    TESTOUTPSL,
                    (TESTOUTCOORDS..., rand(RNG)),
                )
            end
        end
    end
end

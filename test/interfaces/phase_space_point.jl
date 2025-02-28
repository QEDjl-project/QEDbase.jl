using Random
using QEDbase
using QEDbase.Mocks

RNG = MersenneTwister(137137)

@testset "PhaseSpacePoint" begin
    N_INCOMING = 3
    N_OUTGOING = 3
    INCOMING_PARTICLES = (MockBoson(), MockFermion(), MockBoson())
    OUTGOING_PARTICLES = (MockFermion(), MockBoson(), MockFermion())

    @testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float16, Float32, Float64)
        MOM_TYPE = MockMomentum{MOM_EL_TYPE}
        TESTPROC = MockProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)
        TESTMODEL = MockModel()
        TESTPSL = MockOutPhaseSpaceLayout(MOM_TYPE)
        IN_PS = Mocks._rand_momenta(RNG, N_INCOMING, MOM_TYPE)
        OUT_PS = Mocks._rand_momenta(RNG, N_OUTGOING, MOM_TYPE)

        PSP = MockPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSL, IN_PS, OUT_PS)

        @testset "momentum element types" begin
            @test MOM_TYPE == momentum_type(PSP)
            @test MOM_TYPE == momentum_type(typeof(PSP))
            @test MOM_EL_TYPE == momentum_eltype(PSP)
            @test MOM_EL_TYPE == momentum_eltype(typeof(PSP))
        end

        @testset "momentum implementations" begin
            @test @inferred momentum(PSP, Incoming(), MockBoson(), 1) == IN_PS[1]
            @test @inferred momentum(PSP, Incoming(), MockFermion(), 1) == IN_PS[2]
            @test @inferred momentum(PSP, Incoming(), MockFermion()) == IN_PS[2]
            @test @inferred momentum(PSP, Incoming(), MockBoson(), 2) == IN_PS[3]

            @test @inferred momentum(PSP, Outgoing(), MockFermion(), 1) == OUT_PS[1]
            @test @inferred momentum(PSP, Outgoing(), MockBoson(), 1) == OUT_PS[2]
            @test @inferred momentum(PSP, Outgoing(), MockBoson()) == OUT_PS[2]
            @test @inferred momentum(PSP, Outgoing(), MockFermion(), 2) == OUT_PS[3]

            @test @inferred momentum(PSP, Incoming(), MockBoson(), Val(1)) == IN_PS[1]
            @test @inferred momentum(PSP, Incoming(), MockFermion(), Val(1)) == IN_PS[2]
            @test @inferred momentum(PSP, Incoming(), MockBoson(), Val(2)) == IN_PS[3]

            @test @inferred momentum(PSP, Outgoing(), MockFermion(), Val(1)) == OUT_PS[1]
            @test @inferred momentum(PSP, Outgoing(), MockBoson(), Val(1)) == OUT_PS[2]
            @test @inferred momentum(PSP, Outgoing(), MockFermion(), Val(2)) == OUT_PS[3]
        end

        @testset "momentum fails" begin
            @test_throws BoundsError momentum(PSP, Incoming(), 0)
            @test_throws BoundsError momentum(PSP, Outgoing(), 0)
            @test_throws BoundsError momentum(PSP, Incoming(), MockBoson(), 0)
            @test_throws BoundsError momentum(PSP, Outgoing(), MockFermion(), 0)
            @test_throws BoundsError momentum(PSP, Incoming(), 4)
            @test_throws BoundsError momentum(PSP, Outgoing(), 4)
            @test_throws BoundsError momentum(PSP, Incoming(), MockFermion(), 2)
            @test_throws BoundsError momentum(PSP, Incoming(), MockBoson(), 3)
            @test_throws BoundsError momentum(PSP, Outgoing(), MockFermion(), 3)
            @test_throws BoundsError momentum(PSP, Outgoing(), MockBoson(), 2)

            # overload only exists for single particles of that type
            @test_throws InvalidInputError momentum(PSP, Incoming(), MockBoson())
            @test_throws InvalidInputError momentum(PSP, Outgoing(), MockFermion())

            # same for Val() overloads
            @test_throws BoundsError momentum(PSP, Incoming(), MockBoson(), Val(0))
            @test_throws BoundsError momentum(PSP, Outgoing(), MockFermion(), Val(0))
            @test_throws BoundsError momentum(PSP, Incoming(), MockFermion(), Val(2))
            @test_throws BoundsError momentum(PSP, Incoming(), MockBoson(), Val(3))
            @test_throws BoundsError momentum(PSP, Outgoing(), MockFermion(), Val(3))
            @test_throws BoundsError momentum(PSP, Outgoing(), MockBoson(), Val(2))
        end

        @testset "momenta implementation" begin
            @test IN_PS == @inferred momenta(PSP, Incoming())
            @test OUT_PS == @inferred momenta(PSP, Outgoing())
        end
    end
end

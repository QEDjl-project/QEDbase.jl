using Random
using QEDbase

RNG = MersenneTwister(137137)

include("../test_implementation/TestImplementation.jl")
using .TestImplementation

@testset "PhaseSpacePoint" begin
    N_INCOMING = 3
    N_OUTGOING = 3
    INCOMING_PARTICLES = (TestBoson(), TestFermion(), TestBoson())
    OUTGOING_PARTICLES = (TestFermion(), TestBoson(), TestFermion())

    @testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float16, Float32, Float64)
        MOM_TYPE = TestMomentum{MOM_EL_TYPE}
        TESTPROC = TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)
        TESTMODEL = TestModel()
        TESTPSDEF = TestPhasespaceDef{MOM_TYPE}()
        IN_PS = TestImplementation._rand_momenta(RNG, N_INCOMING, MOM_TYPE)
        OUT_PS = TestImplementation._rand_momenta(RNG, N_OUTGOING, MOM_TYPE)

        PSP = TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, IN_PS, OUT_PS)

        @testset "momentum implementations" begin
            @test @inferred momentum(PSP, Incoming(), TestBoson(), 1) == IN_PS[1]
            @test @inferred momentum(PSP, Incoming(), TestFermion(), 1) == IN_PS[2]
            @test @inferred momentum(PSP, Incoming(), TestFermion()) == IN_PS[2]
            @test @inferred momentum(PSP, Incoming(), TestBoson(), 2) == IN_PS[3]

            @test @inferred momentum(PSP, Outgoing(), TestFermion(), 1) == OUT_PS[1]
            @test @inferred momentum(PSP, Outgoing(), TestBoson(), 1) == OUT_PS[2]
            @test @inferred momentum(PSP, Outgoing(), TestBoson()) == OUT_PS[2]
            @test @inferred momentum(PSP, Outgoing(), TestFermion(), 2) == OUT_PS[3]

            @test @inferred momentum(PSP, Incoming(), TestBoson(), Val(1)) == IN_PS[1]
            @test @inferred momentum(PSP, Incoming(), TestFermion(), Val(1)) == IN_PS[2]
            @test @inferred momentum(PSP, Incoming(), TestBoson(), Val(2)) == IN_PS[3]

            @test @inferred momentum(PSP, Outgoing(), TestFermion(), Val(1)) == OUT_PS[1]
            @test @inferred momentum(PSP, Outgoing(), TestBoson(), Val(1)) == OUT_PS[2]
            @test @inferred momentum(PSP, Outgoing(), TestFermion(), Val(2)) == OUT_PS[3]
        end

        @testset "momentum fails" begin
            @test_throws BoundsError momentum(PSP, Incoming(), 0)
            @test_throws BoundsError momentum(PSP, Outgoing(), 0)
            @test_throws BoundsError momentum(PSP, Incoming(), TestBoson(), 0)
            @test_throws BoundsError momentum(PSP, Outgoing(), TestFermion(), 0)
            @test_throws BoundsError momentum(PSP, Incoming(), 4)
            @test_throws BoundsError momentum(PSP, Outgoing(), 4)
            @test_throws BoundsError momentum(PSP, Incoming(), TestFermion(), 2)
            @test_throws BoundsError momentum(PSP, Incoming(), TestBoson(), 3)
            @test_throws BoundsError momentum(PSP, Outgoing(), TestFermion(), 3)
            @test_throws BoundsError momentum(PSP, Outgoing(), TestBoson(), 2)

            # overload only exists for single particles of that type
            @test_throws InvalidInputError momentum(PSP, Incoming(), TestBoson())
            @test_throws InvalidInputError momentum(PSP, Outgoing(), TestFermion())

            # same for Val() overloads
            @test_throws BoundsError momentum(PSP, Incoming(), TestBoson(), Val(0))
            @test_throws BoundsError momentum(PSP, Outgoing(), TestFermion(), Val(0))
            @test_throws BoundsError momentum(PSP, Incoming(), TestFermion(), Val(2))
            @test_throws BoundsError momentum(PSP, Incoming(), TestBoson(), Val(3))
            @test_throws BoundsError momentum(PSP, Outgoing(), TestFermion(), Val(3))
            @test_throws BoundsError momentum(PSP, Outgoing(), TestBoson(), Val(2))
        end

        @testset "momenta implementation" begin
            @test IN_PS == @inferred momenta(PSP, Incoming())
            @test OUT_PS == @inferred momenta(PSP, Outgoing())
        end
    end
end

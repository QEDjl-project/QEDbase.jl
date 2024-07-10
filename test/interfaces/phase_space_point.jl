using Random
using QEDbase
using QEDcore

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("../test_implementation/TestImplementation.jl")

const TestBoson = TestImplementation.TestParticleBoson
const TestFermion = TestImplementation.TestParticleFermion

@testset "PhaseSpacePoint" begin
    N_INCOMING = 3
    N_OUTGOING = 3
    INCOMING_PARTICLES = (TestBoson(), TestFermion(), TestBoson())
    OUTGOING_PARTICLES = (TestFermion(), TestBoson(), TestFermion())

    TESTPROC = TestImplementation.TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)
    TESTMODEL = TestImplementation.TestModel()
    TESTPSDEF = TestImplementation.TestPhasespaceDef()
    IN_PS = TestImplementation._rand_momenta(RNG, N_INCOMING)
    OUT_PS = TestImplementation._rand_momenta(RNG, N_OUTGOING)

    PSP = PhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, IN_PS, OUT_PS)

    @testset "momentum implementations" begin
        @test momentum(PSP, Incoming(), TestBoson(), 1) == IN_PS[1]
        @test momentum(PSP, Incoming(), TestFermion(), 1) == IN_PS[2]
        @test momentum(PSP, Incoming(), TestFermion()) == IN_PS[2]
        @test momentum(PSP, Incoming(), TestBoson(), 2) == IN_PS[3]

        @test momentum(PSP, Outgoing(), TestFermion(), 1) == OUT_PS[1]
        @test momentum(PSP, Outgoing(), TestBoson(), 1) == OUT_PS[2]
        @test momentum(PSP, Outgoing(), TestBoson()) == OUT_PS[2]
        @test momentum(PSP, Outgoing(), TestFermion(), 2) == OUT_PS[3]

        @test momentum(PSP, Incoming(), TestBoson(), Val(1)) == IN_PS[1]
        @test momentum(PSP, Incoming(), TestFermion(), Val(1)) == IN_PS[2]
        @test momentum(PSP, Incoming(), TestBoson(), Val(2)) == IN_PS[3]

        @test momentum(PSP, Outgoing(), TestFermion(), Val(1)) == OUT_PS[1]
        @test momentum(PSP, Outgoing(), TestBoson(), Val(1)) == OUT_PS[2]
        @test momentum(PSP, Outgoing(), TestFermion(), Val(2)) == OUT_PS[3]
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
        @test IN_PS == momenta(PSP, Incoming())
        @test OUT_PS == momenta(PSP, Outgoing())
    end
end

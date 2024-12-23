using Random
using QEDbase

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("../test_implementation/TestImplementation.jl")
using .TestImplementation

@testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in Iterators.product(
    (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
)
    INCOMING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_INCOMING))
    OUTGOING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_OUTGOING))

    TESTPROC = TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)
    TESTMODEL = TestModel()
    TESTPSDEF = TestPhasespaceDef{TestMomentum{Float64}}()
    IN_PS = TestImplementation._rand_momenta(RNG, N_INCOMING, TestMomentum{Float64})
    OUT_PS = TestImplementation._rand_momenta(RNG, N_OUTGOING, TestMomentum{Float64})
    PSP = TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, IN_PS, OUT_PS)

    @testset "failed interface" begin
        TESTPROC_FAIL_ALL = TestImplementation.TestProcess_FAIL_ALL(
            INCOMING_PARTICLES, OUTGOING_PARTICLES
        )

        @testset "failed process interface" begin
            @test_throws MethodError incoming_particles(TESTPROC_FAIL_ALL)
            @test_throws MethodError outgoing_particles(TESTPROC_FAIL_ALL)
            @test_throws MethodError incoming_spin_pols(TESTPROC_FAIL_ALL)
            @test_throws MethodError outgoing_spin_pols(TESTPROC_FAIL_ALL)
        end
    end

    @testset "broadcast" begin
        test_func(proc::AbstractProcessDefinition) = proc
        @test test_func.(TESTPROC) == TESTPROC
    end

    @testset "incoming/outgoing particles" begin
        @test @inferred incoming_particles(TESTPROC) == INCOMING_PARTICLES
        @test @inferred outgoing_particles(TESTPROC) == OUTGOING_PARTICLES
        @test @inferred particles(TESTPROC, Incoming()) == INCOMING_PARTICLES
        @test @inferred particles(TESTPROC, Outgoing()) == OUTGOING_PARTICLES
        @test @inferred number_incoming_particles(TESTPROC) == N_INCOMING
        @test @inferred number_outgoing_particles(TESTPROC) == N_OUTGOING
        @test @inferred number_particles(TESTPROC, Incoming()) == N_INCOMING
        @test @inferred number_particles(TESTPROC, Outgoing()) == N_OUTGOING

        @testset "$dir $species" for (dir, species) in Iterators.product(
            (Incoming(), Outgoing()), TestImplementation.PARTICLE_SET
        )
            groundtruth_particle_count = count(x -> x == species, particles(TESTPROC, dir))
            test_ps = TestParticleStateful(dir, species, zero(TestMomentum{Float64}))

            @test @inferred number_particles(TESTPROC, dir, species) ==
                groundtruth_particle_count
            @test @inferred number_particles(TESTPROC, test_ps) ==
                groundtruth_particle_count
        end
    end

    @testset "incoming/outgoing spins and polarizations" begin
        groundtruth_incoming_spin_pols = ntuple(
            x -> is_fermion(INCOMING_PARTICLES[x]) ? AllSpin() : AllPolarization(),
            N_INCOMING,
        )
        groundtruth_outgoing_spin_pols = ntuple(
            x -> is_fermion(OUTGOING_PARTICLES[x]) ? AllSpin() : AllPolarization(),
            N_OUTGOING,
        )

        @test @inferred incoming_spin_pols(TESTPROC) == groundtruth_incoming_spin_pols
        @test @inferred outgoing_spin_pols(TESTPROC) == groundtruth_outgoing_spin_pols
        @test @inferred spin_pols(TESTPROC, Incoming()) == groundtruth_incoming_spin_pols
        @test @inferred spin_pols(TESTPROC, Outgoing()) == groundtruth_outgoing_spin_pols

        for (pt, sp) in Iterators.flatten((
            Iterators.zip(incoming_particles(TESTPROC), incoming_spin_pols(TESTPROC)),
            Iterators.zip(outgoing_particles(TESTPROC), outgoing_spin_pols(TESTPROC)),
        ))
            @test is_boson(pt) ? sp isa AbstractPolarization : true
            @test is_fermion(pt) ? sp isa AbstractSpin : true
            @test is_boson(pt) || is_fermion(pt)
        end
    end
end

@testset "Process Multiplicity" begin
    boson = TestBoson()
    fermion = TestFermion()

    _mult(::AbstractDefinitePolarization) = 1
    _mult(::AbstractDefiniteSpin) = 1
    _mult(::AbstractIndefinitePolarization) = 2
    _mult(::AbstractIndefiniteSpin) = 2

    @testset "no synced spins/pols" begin # test all possible combinations for fermion+boson->fermion+boson processes, without synced
        spins = (SpinUp(), SpinDown(), AllSpin())
        pols = (PolX(), PolY(), AllPol())
        for (p1, s1, p2, s2) in Iterators.product(pols, spins, pols, spins)
            proc = TestImplementation.TestProcessSP(
                (boson, fermion), (boson, fermion), (p1, s1), (p2, s2)
            )
            @test @inferred multiplicity(proc) == prod(_mult.((p1, s1, p2, s2)))
            @test @inferred incoming_multiplicity(proc) == prod(_mult.((p1, s1)))
            @test @inferred outgoing_multiplicity(proc) == prod(_mult.((p2, s2)))
        end
    end

    # some special cases for synced spins and pols testing
    for i in 1:4
        # i synced bosons
        proc = TestImplementation.TestProcessSP(
            (ntuple(_ -> boson, i)..., fermion),
            (boson, fermion),
            (ntuple(_ -> SyncedPolarization(1), i)..., AllSpin()),
            (AllPol(), AllSpin()),
        )
        @test @inferred multiplicity(proc) == 16
        @test @inferred incoming_multiplicity(proc) == 4
        @test @inferred outgoing_multiplicity(proc) == 4

        proc = TestImplementation.TestProcessSP(
            (boson, fermion),
            (ntuple(_ -> boson, i)..., fermion),
            (AllPol(), SpinDown()),
            (ntuple(_ -> SyncedPolarization(1), i)..., AllSpin()),
        )
        @test @inferred multiplicity(proc) == 8
        @test @inferred incoming_multiplicity(proc) == 2
        @test @inferred outgoing_multiplicity(proc) == 4

        for j in 1:4
            # ... with j synced fermions
            proc = TestImplementation.TestProcessSP(
                (ntuple(_ -> boson, i)..., fermion),
                (boson, ntuple(_ -> fermion, j)),
                (ntuple(_ -> SyncedPolarization(1), i)..., SpinDown()),
                (PolX(), ntuple(_ -> SyncedSpin(1), j)...),
            )
            @test @inferred multiplicity(proc) == 4
            @test @inferred incoming_multiplicity(proc) == 2
            @test @inferred outgoing_multiplicity(proc) == 2
        end
    end

    @testset "multiple differing synced polarizations" begin
        proc = TestImplementation.TestProcessSP(
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(_ -> SyncedPolarization(1), 2)..., SpinUp()),
            (ntuple(_ -> SyncedPolarization(2), 2)..., AllSpin()),
        )
        @test @inferred multiplicity(proc) == 8
        @test @inferred incoming_multiplicity(proc) == 2
        @test @inferred outgoing_multiplicity(proc) == 4
    end

    @testset "synced polarization across in and out particles" begin
        proc = TestImplementation.TestProcessSP(
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(i -> SyncedPolarization(i), 2)..., SpinUp()),
            (ntuple(i -> SyncedPolarization(i), 2)..., SpinDown()),
        )
        @test @inferred multiplicity(proc) == 4
        @test @inferred incoming_multiplicity(proc) == 4
        @test @inferred outgoing_multiplicity(proc) == 4
    end
end

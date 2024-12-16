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

        #TODO: move to cross section
        TESTPROC_FAIL_DIFFCS = TestImplementation.TestProcess_FAIL_DIFFCS(
            INCOMING_PARTICLES, OUTGOING_PARTICLES
        )

        #TODO: move to cross section
        TESTMODEL_FAIL = TestImplementation.TestModel_FAIL()
        TESTPSDEF_FAIL = TestImplementation.TestPhasespaceDef_FAIL()

        @testset "failed process interface" begin
            @test_throws MethodError incoming_particles(TESTPROC_FAIL_ALL)
            @test_throws MethodError outgoing_particles(TESTPROC_FAIL_ALL)
            @test_throws MethodError incoming_spin_pols(TESTPROC_FAIL_ALL)
            @test_throws MethodError outgoing_spin_pols(TESTPROC_FAIL_ALL)
        end

        @testset "$PROC $MODEL" for (PROC, MODEL) in Iterators.product(
            (TESTPROC, TESTPROC_FAIL_DIFFCS), (TESTMODEL, TESTMODEL_FAIL)
        )
            #TODO: move to cross section
            if TestImplementation._any_fail(PROC, MODEL)
                psp = TestPhaseSpacePoint(PROC, MODEL, TESTPSDEF, IN_PS, OUT_PS)
                @test_throws MethodError QEDbase._incident_flux(psp)
                @test_throws MethodError QEDbase._averaging_norm(psp)
                @test_throws MethodError QEDbase._matrix_element(psp)
            end

            #TODO: move to cross section
            for PS_DEF in (TESTPSDEF, TESTPSDEF_FAIL)
                if TestImplementation._any_fail(PROC, MODEL, PS_DEF)
                    psp = TestPhaseSpacePoint(PROC, MODEL, PS_DEF, IN_PS, OUT_PS)
                    @test_throws MethodError QEDbase._phase_space_factor(psp)
                end
            end
        end
    end

    @testset "broadcast" begin
        test_func(proc::AbstractProcessDefinition) = proc
        @test test_func.(TESTPROC) == TESTPROC

        #TODO: move to model
        test_func(model::AbstractModelDefinition) = model
        @test test_func.(TESTMODEL) == TESTMODEL
    end

    @testset "incoming/outgoing particles" begin
        @test incoming_particles(TESTPROC) == INCOMING_PARTICLES
        @test outgoing_particles(TESTPROC) == OUTGOING_PARTICLES
        @test particles(TESTPROC, Incoming()) == INCOMING_PARTICLES
        @test particles(TESTPROC, Outgoing()) == OUTGOING_PARTICLES
        @test number_incoming_particles(TESTPROC) == N_INCOMING
        @test number_outgoing_particles(TESTPROC) == N_OUTGOING
        @test number_particles(TESTPROC, Incoming()) == N_INCOMING
        @test number_particles(TESTPROC, Outgoing()) == N_OUTGOING

        @testset "$dir $species" for (dir, species) in Iterators.product(
            (Incoming(), Outgoing()), TestImplementation.PARTICLE_SET
        )
            groundtruth_particle_count = count(x -> x == species, particles(TESTPROC, dir))
            test_ps = TestParticleStateful(dir, species, zero(TestMomentum{Float64}))

            @test number_particles(TESTPROC, dir, species) == groundtruth_particle_count
            @test number_particles(TESTPROC, test_ps) == groundtruth_particle_count
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

        @test incoming_spin_pols(TESTPROC) == groundtruth_incoming_spin_pols
        @test outgoing_spin_pols(TESTPROC) == groundtruth_outgoing_spin_pols
        @test spin_pols(TESTPROC, Incoming()) == groundtruth_incoming_spin_pols
        @test spin_pols(TESTPROC, Outgoing()) == groundtruth_outgoing_spin_pols

        for (pt, sp) in Iterators.flatten((
            Iterators.zip(incoming_particles(TESTPROC), incoming_spin_pols(TESTPROC)),
            Iterators.zip(outgoing_particles(TESTPROC), outgoing_spin_pols(TESTPROC)),
        ))
            @test is_boson(pt) ? sp isa AbstractPolarization : true
            @test is_fermion(pt) ? sp isa AbstractSpin : true
            @test is_boson(pt) || is_fermion(pt)
        end
    end

    #TODO: move to cross section
    @testset "incident flux" begin
        test_incident_flux = QEDbase._incident_flux(
            TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, IN_PS, ())
        )
        groundtruth = TestImplementation._groundtruth_incident_flux(IN_PS)
        @test isapprox(test_incident_flux, groundtruth, atol=ATOL, rtol=RTOL)

        test_incident_flux = QEDbase._incident_flux(
            TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, IN_PS, OUT_PS)
        )
        @test isapprox(test_incident_flux, groundtruth, atol=ATOL, rtol=RTOL)

        #@test_throws MethodError QEDbase._incident_flux(
        #    OutPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, OUT_PS)
        #)
    end

    #TODO: move to cross section
    @testset "averaging norm" begin
        test_avg_norm = QEDbase._averaging_norm(TESTPROC)
        groundtruth = TestImplementation._groundtruth_averaging_norm(TESTPROC)
        @test isapprox(test_avg_norm, groundtruth, atol=ATOL, rtol=RTOL)
    end

    #TODO: move to cross section
    @testset "matrix element" begin
        test_matrix_element = QEDbase._matrix_element(PSP)
        groundtruth = TestImplementation._groundtruth_matrix_element(IN_PS, OUT_PS)
        @test length(test_matrix_element) == length(groundtruth)
        for i in eachindex(test_matrix_element)
            @test isapprox(test_matrix_element[i], groundtruth[i], atol=ATOL, rtol=RTOL)
        end
    end

    #TODO: move to cross section
    @testset "is in phasespace" begin
        @test QEDbase._is_in_phasespace(PSP)

        IN_PS_unphysical = (zero(TestMomentum{Float64}), IN_PS[2:end]...)
        OUT_PS_unphysical = (OUT_PS[1:(end - 1)]..., ones(TestMomentum{Float64}))
        PSP_unphysical_in_ps = TestPhaseSpacePoint(
            TESTPROC, TESTMODEL, TESTPSDEF, IN_PS_unphysical, OUT_PS
        )
        PSP_unphysical_out_ps = TestPhaseSpacePoint(
            TESTPROC, TESTMODEL, TESTPSDEF, IN_PS, OUT_PS_unphysical
        )
        PSP_unphysical = TestPhaseSpacePoint(
            TESTPROC, TESTMODEL, TESTPSDEF, IN_PS_unphysical, OUT_PS_unphysical
        )

        @test !QEDbase._is_in_phasespace(PSP_unphysical_in_ps)
        @test !QEDbase._is_in_phasespace(PSP_unphysical_out_ps)
        @test !QEDbase._is_in_phasespace(PSP_unphysical)
    end

    #TODO: move to cross section
    @testset "phase space factor" begin
        test_phase_space_factor = QEDbase._phase_space_factor(PSP)
        groundtruth = TestImplementation._groundtruth_phase_space_factor(IN_PS, OUT_PS)
        @test isapprox(test_phase_space_factor, groundtruth, atol=ATOL, rtol=RTOL)
    end

    #TODO: move to phase space layout?
    #=
    @testset "generate momenta" begin
        ps_in_coords = Tuple(rand(RNG, 4 * N_INCOMING))
        ps_out_coords = Tuple(rand(RNG, 4 * N_OUTGOING))

        groundtruth_in_momenta = TestImplementation._groundtruth_generate_momenta(
            ps_in_coords, TestMomentum{Float64}
        )
        groundtruth_out_momenta = TestImplementation._groundtruth_generate_momenta(
            ps_out_coords, TestMomentum{Float64}
        )

        @test groundtruth_in_momenta == QEDbase._generate_incoming_momenta(
            TESTPROC, TESTMODEL, TESTPSDEF, ps_in_coords
        )
        @test groundtruth_out_momenta == QEDbase._generate_outgoing_momenta(
            TESTPROC, TESTMODEL, TESTPSDEF, ps_in_coords, ps_out_coords
        )
        @test (groundtruth_in_momenta, groundtruth_out_momenta) ==
            QEDbase._generate_momenta(
            TESTPROC, TESTMODEL, TESTPSDEF, ps_in_coords, ps_out_coords
        )

        groundtruth_psp = TestPhaseSpacePoint(
            TESTPROC, TESTMODEL, TESTPSDEF, groundtruth_in_momenta, groundtruth_out_momenta
        )
        groundtruth_in_psp = TestPhaseSpacePoint(
            TESTPROC, TESTMODEL, TESTPSDEF, groundtruth_in_momenta,()
        )

        @test groundtruth_psp ==
            TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, ps_in_coords, ps_out_coords)
        @test groundtruth_in_psp ==
        TestPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, ps_in_coords,())
    end
    =#
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
            @test multiplicity(proc) == prod(_mult.((p1, s1, p2, s2)))
            @test incoming_multiplicity(proc) == prod(_mult.((p1, s1)))
            @test outgoing_multiplicity(proc) == prod(_mult.((p2, s2)))
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
        @test multiplicity(proc) == 16
        @test incoming_multiplicity(proc) == 4
        @test outgoing_multiplicity(proc) == 4

        proc = TestImplementation.TestProcessSP(
            (boson, fermion),
            (ntuple(_ -> boson, i)..., fermion),
            (AllPol(), SpinDown()),
            (ntuple(_ -> SyncedPolarization(1), i)..., AllSpin()),
        )
        @test multiplicity(proc) == 8
        @test incoming_multiplicity(proc) == 2
        @test outgoing_multiplicity(proc) == 4

        for j in 1:4
            # ... with j synced fermions
            proc = TestImplementation.TestProcessSP(
                (ntuple(_ -> boson, i)..., fermion),
                (boson, ntuple(_ -> fermion, j)),
                (ntuple(_ -> SyncedPolarization(1), i)..., SpinDown()),
                (PolX(), ntuple(_ -> SyncedSpin(1), j)...),
            )
            @test multiplicity(proc) == 4
            @test incoming_multiplicity(proc) == 2
            @test outgoing_multiplicity(proc) == 2
        end
    end

    @testset "multiple differing synced polarizations" begin
        proc = TestImplementation.TestProcessSP(
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(_ -> SyncedPolarization(1), 2)..., SpinUp()),
            (ntuple(_ -> SyncedPolarization(2), 2)..., AllSpin()),
        )
        @test multiplicity(proc) == 8
        @test incoming_multiplicity(proc) == 2
        @test outgoing_multiplicity(proc) == 4
    end

    @testset "synced polarization across in and out particles" begin
        proc = TestImplementation.TestProcessSP(
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(_ -> boson, 2)..., fermion),
            (ntuple(i -> SyncedPolarization(i), 2)..., SpinUp()),
            (ntuple(i -> SyncedPolarization(i), 2)..., SpinDown()),
        )
        @test multiplicity(proc) == 4
        @test incoming_multiplicity(proc) == 4
        @test outgoing_multiplicity(proc) == 4
    end
end

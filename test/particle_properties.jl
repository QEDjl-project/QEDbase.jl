using StaticArrays
using Random
using QEDbase
using QEDbase.Mocks

# test function to test scalar broadcasting
test_broadcast(x::AbstractParticle) = x
test_broadcast(x::ParticleDirection) = x
test_broadcast(x::AbstractSpinOrPolarization) = x

@testset "scalar broadcasting" begin
    @testset "directions" begin
        @testset "$dir" for dir in (Incoming(), Outgoing(), UnknownDirection())
            @test test_broadcast.(dir) == dir
        end
    end

    @testset "spins and polarization" begin
        @testset "$spin_or_pol" for spin_or_pol in (
            SpinUp(),
            SpinDown(),
            AllSpin(),
            PolX(),
            PolY(),
            AllPol(),
            SyncedSpin(1),
            SyncedPolarization(1),
        )
            @test test_broadcast.(spin_or_pol) == spin_or_pol
        end
    end
end

TESTPROCS = (
    Mocks.MockProcessSP(
        (MockBoson(), MockFermion()),
        (MockBoson(), MockFermion()),
        (AllPol(), AllSpin()),
        (AllPol(), AllSpin()),
    ),
    Mocks.MockProcessSP(
        (MockBoson(), MockBoson(), MockFermion()),
        (MockBoson(), MockFermion()),
        (SyncedPol(1), SyncedPol(1), AllSpin()),
        (AllPol(), AllSpin()),
    ),
    Mocks.MockProcessSP(
        (MockBoson(), MockBoson(), MockFermion()),
        (MockBoson(), MockFermion()),
        (SyncedPol(1), SyncedPol(2), SyncedSpin(2)),
        (SyncedPol(2), SyncedSpin(2)),
    ),
)

@testset "spin_pol iterator ($proc)" for proc in TESTPROCS
    @test length(spin_pols_iter(proc)) == multiplicity(proc)

    for combinations in spin_pols_iter(proc)
        @test length(combinations) == 2
        in_comb, out_comb = combinations

        @test length(in_comb) == length(incoming_particles(proc))
        @test length(out_comb) == length(outgoing_particles(proc))

        for sp in Iterators.flatten((in_comb, out_comb))
            @test sp isa AbstractDefiniteSpin || sp isa AbstractDefinitePolarization
        end
    end
end

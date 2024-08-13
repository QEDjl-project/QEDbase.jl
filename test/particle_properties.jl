using QEDbase
using StaticArrays
using Random

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
            SyncedSpin{1}(),
            SyncedPolarization{1}(),
        )
            @test test_broadcast.(spin_or_pol) == spin_or_pol
        end
    end
end

using QEDbase
using StaticArrays
using Random

# test function to test scalar broadcasting
test_broadcast(x::AbstractParticle) = x
test_broadcast(x::ParticleDirection) = x
test_broadcast(x::AbstractSpinOrPolarization) = x

@testset "scalar broadcasting" begin
    @testset "directions" begin
        @testset "$dir" for dir in (Incoming(), Outgoing())
            @test test_broadcast.(dir) == dir
        end
    end

    @testset "spins and polarization" begin
        @testset "$spin_or_pol" for spin_or_pol in (
            SpinUp(), SpinDown(), AllSpin(), PolX(), PolY(), AllPol()
        )
            @test test_broadcast.(spin_or_pol) == spin_or_pol
        end
    end
end

@testset "multiplicity of spins or pols" begin
    @testset "single" begin
        @testset "$spin_or_pol" for spin_or_pol in (SpinUp(), SpinDown(), PolX(), PolY())
            @test multiplicity(spin_or_pol) == 1
        end
    end
    @testset "multiple" begin
        @testset "$spin_or_pol" for spin_or_pol in (AllSpin(), AllPol())
            @test multiplicity(spin_or_pol) == 2
        end
    end
end

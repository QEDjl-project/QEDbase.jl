using Random

const ATOL = 1e-15

@testset "FourMomentum getter" for MomentumType in [SFourMomentum, MFourMomentum]
    rng = MersenneTwister(12345)
    x,y,z = rand(rng,3)
    mass = rand(rng)
    P = MomentumType(sqrt(x^2 + y^2 + z^2 + mass^2),x,y,z)

    @testset "magnitude" begin
        @test getMagnitude2(mom) == getMag2(mom)
        @test getMagnitude2(mom) == mom.x^2 + mom.y^2 + mom.z^2
        @test getMagnitude(mom) == getMag(mom)
        @test getMagnitude(mom) == sqrt(mom.x^2 + mom.y^2 + mom.z^2)
        @test getMagnitude(mom) == sqrt(getMagnitude2(mom))
    end

    @testset "mass" begin
        @test getInvariantMass2(mom) == getMass2(mom)
        @test getInvariantMass2(mom) == mom.t^2 - (mom.x^2 + mom.y^2 + mom.z^2)
        @test getInvariantMass(mom) == getMass(mom)
        @test getInvariantMass(mom) == sqrt(mom.t^2 - (mom.x^2 + mom.y^2 + mom.z^2))
        @test getInvariantMass(mom) == sqrt(getInvariantMass2(mom))
    end

end # FourMomentum getter
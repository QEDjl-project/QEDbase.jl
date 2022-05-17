using Random

const ATOL = 1e-15

@testset "FourMomentum getter" for MomentumType in [SFourMomentum, MFourMomentum]
    rng = MersenneTwister(12345)
    x,y,z = rand(rng, 3)
    mass = rand(rng)
    E = sqrt(x^2 + y^2 + z^2 + mass^2)
    mom_onshell = MomentumType(E, x, y, z)
    mom_zero = MomentumType(0.0, 0.0, 0.0, 0.0)
    mom_offshell = MomentumType(0.0, 0.0, 0.0, mass)

    @testset "magnitude consistence" for mom in [mom_onshell, mom_offshell,mom_zero]
        @test getMagnitude2(mom) == getMag2(mom)
        @test getMagnitude(mom) == getMag(mom)
        @test isapprox(getMagnitude(mom), sqrt(getMagnitude2(mom)))
    end

    @testset "magnitude values" begin
        @test isapprox(getMagnitude2(mom_onshell), x^2 + y^2 + z^2)
        @test isapprox(getMagnitude(mom_onshell), sqrt(x^2 + y^2 + z^2))
    end

    @testset "mass consistence" for mom_on in [mom_onshell, mom_zero]
        @test getInvariantMass2(mom_on) == getMass2(mom_on)
        @test getInvariantMass(mom_on) == getMass(mom_on)
        @test isapprox(getInvariantMass(mom_on), sqrt(getInvariantMass2(mom_on)))
    end

    @testset "mass value" begin
        @test isapprox(getInvariantMass2(mom_onshell), E^2 - (x^2 + y^2 + z^2))
        @test isapprox(getInvariantMass(mom_onshell), sqrt(E^2 - (x^2 + y^2 + z^2)))
        
        @test isapprox(getInvariantMass(mom_onshell), mass)
        @test isapprox(getInvariantMass(mom_offshell), -mass)
        @test isapprox(getInvariantMass(mom_zero), 0.0)
    end

    @testset "momentum components" begin
        @test getE(mom_onshell) == E
        @test getEnergy(mom_onshell) == getE(mom_onshell)
        @test getPx(mom_onshell) == x
        @test getPy(mom_onshell) == y
        @test getPz(mom_onshell) == z

        @test isapprox(getBeta(mom_onshell), sqrt(x^2 + y^2 + z^2)/E)
        @test isapprox(getGamma(mom_onshell), 1/sqrt(1.0 - getBeta(mom_onshell)^2))

        @test getE(mom_zero) == 0.0
        @test getEnergy(mom_zero) == 0.0
        @test getPx(mom_zero) == 0.0
        @test getPy(mom_zero) == 0.0
        @test getPz(mom_zero) == 0.0

        @test isapprox(getBeta(mom_zero), 0.0)
        @test isapprox(getGamma(mom_zero), 1.0)

    end

    @testset "transverse coordinates" for mom_on in [mom_onshell, mom_zero]
        
        @test getTransverseMomentum2(mom_on) == getPt2(mom_on)
        @test getTransverseMomentum2(mom_on) == getPerp2(mom_on)
        @test getTransverseMomentum(mom_on) == getPt(mom_on)
        @test getTransverseMomentum(mom_on) == getPerp(mom_on)

        @test isapprox(getPt(mom_on), sqrt(getPt2(mom_on)))
        
        @test getTransverseMass2(mom_on) == getMt2(mom_on)        
        @test getTransverseMass(mom_on) == getMt(mom_on)
    end

    @testset "transverse coordiantes value" begin
        @test isapprox(getTransverseMomentum2(mom_onshell), x^2 + y^2)
        @test isapprox(getTransverseMomentum(mom_onshell), sqrt(x^2 + y^2))
        @test isapprox(getTransverseMass2(mom_onshell), E^2 - z^2)
        @test isapprox(getTransverseMass(mom_onshell), sqrt(E^2 - z^2))
        @test isapprox(getMt(mom_offshell), -mass)
        @test isapprox(getRapidity(mom_onshell), 0.5*log((E + z)/(E - z)))


        @test isapprox(getTransverseMomentum2(mom_zero), 0.0)
        @test isapprox(getTransverseMomentum(mom_zero), 0.0)
        @test isapprox(getTransverseMass2(mom_zero), 0.0)
        @test isapprox(getTransverseMass(mom_zero), 0.0)
        @test isapprox(getMt(mom_zero), 0.0)
    end

    @testset "spherical coordiantes consistence" for mom_on in [mom_onshell, mom_zero]
        @test getRho2(mom_on) == getMagnitude2(mom_on)
        @test getRho(mom_on) == getMagnitude(mom_on)

        @test isapprox(getCosTheta(mom_on), cos(getTheta(mom_on)))
        @test isapprox(getCosPhi(mom_on), cos(getPhi(mom_on)))
        @test isapprox(getSinPhi(mom_on), sin(getPhi(mom_on)))
    end

    @testset "spherical coordiantes values" begin
        @test isapprox(getTheta(mom_onshell), atan(getPt(mom_onshell), z))
        @test isapprox(getTheta(mom_zero), 0.0)

        @test isapprox(getPhi(mom_onshell), atan(y,x))
        @test isapprox(getPhi(mom_zero), 0.0)
    end

    @testset "light-cone coordiantes" begin
        @test isapprox(getPlus(mom_onshell), 0.5*(E + z))
        @test isapprox(getMinus(mom_onshell), 0.5*(E - z))

        @test isapprox(getPlus(mom_zero), 0.0)
        @test isapprox(getMinus(mom_zero), 0.0)
    end

end # FourMomentum getter


function test_get_set(rng, setter, getter; value = rand(rng))
    x,y,z = rand(rng, 3)
    mass = rand(rng)
    E = sqrt(x^2 + y^2 + z^2 + mass^2)
    mom = MFourMomentum(E, x, y, z)
    setter(mom, value)
    return isapprox(getter(mom), value)
end

@testset "FourMomentum setter" begin
    rng = MersenneTwister(123456)

    @testset "Momentum components" begin
        @test test_get_set(rng, setE!, getE)
        @test test_get_set(rng, setEnergy!, getE)
        @test test_get_set(rng, setPx!, getPx)
        @test test_get_set(rng, setPy!, getPy)
        @test test_get_set(rng, setPz!, getPz)
    end

    @testset "spherical coordiantes" begin
        @test test_get_set(rng, setTheta!, getTheta)
        @test test_get_set(rng, setTheta!, getTheta, value = 0.0)
        @test test_get_set(rng, setCosTheta!, getCosTheta)
        @test test_get_set(rng, setCosTheta!, getCosTheta, value = 1.0)
        @test test_get_set(rng, setPhi!, getPhi)
        @test test_get_set(rng, setPhi!, getPhi, value = 0.0)
        @test test_get_set(rng, setRho!, getRho)
        @test test_get_set(rng, setRho!, getRho, value = 0.0)
    end

    @testset "light-cone coordiantes" begin
        @test test_get_set(rng, setPlus!, getPlus)
        @test test_get_set(rng, setPlus!, getPlus, value = 0.0)
        @test test_get_set(rng, setMinus!, getMinus)
        @test test_get_set(rng, setMinus!, getMinus, value = 0.0)
    end

    @testset "transverse coordinates" begin
        @test test_get_set(rng, setTransverseMomentum!, getTransverseMomentum)
        @test test_get_set(rng, setTransverseMomentum!, getTransverseMomentum, value = 0.0)
        @test test_get_set(rng, setPerp!, getTransverseMomentum)
        @test test_get_set(rng, setPt!, getTransverseMomentum)
        @test test_get_set(rng, setTransverseMass!, getTransverseMass)
        @test test_get_set(rng, setTransverseMass!, getTransverseMass, value = 0.0)
        @test test_get_set(rng, setMt!, getTransverseMass)
        @test test_get_set(rng, setRapidity!, getRapidity)
        @test test_get_set(rng, setRapidity!, getRapidity, value = 0.0)
    end
end # FourMomentum setter

@testset "isonshell" begin
    rng = MersenneTwister(42)
    x,y,z,m = rand(rng, 4)

    E_photon  = sqrt(x^2 + y^2 + z^2 + 0.0)
    E_fermion = sqrt(x^2 + y^2 + z^2 + m^2)
    mom_photon  = SFourMomentum(E_photon, x, y, z)
    mom_fermion = SFourMomentum(E_fermion, x, y, z)
	@test isonshell(mom_photon, 0.0)
	@test isonshell(mom_fermion, m)
end
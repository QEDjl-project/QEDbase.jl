using QEDbase
using QEDcore
using Random

const ATOL = 1e-15

@testset "FourMomentum getter" for MomentumType in [SFourMomentum, MFourMomentum]
    rng = MersenneTwister(12345)
    x, y, z = rand(rng, 3)
    mass = rand(rng)
    E = sqrt(x^2 + y^2 + z^2 + mass^2)
    mom_onshell = MomentumType(E, x, y, z)
    mom_zero = MomentumType(0.0, 0.0, 0.0, 0.0)
    mom_offshell = MomentumType(0.0, 0.0, 0.0, mass)

    @testset "magnitude consistence" for mom in [mom_onshell, mom_offshell, mom_zero]
        @test QEDbase.getMagnitude2(mom) == QEDbase.getMag2(mom)
        @test QEDbase.getMagnitude(mom) == QEDbase.getMag(mom)
        @test isapprox(QEDbase.getMagnitude(mom), sqrt(QEDbase.getMagnitude2(mom)))
    end

    @testset "magnitude values" begin
        @test isapprox(QEDbase.getMagnitude2(mom_onshell), x^2 + y^2 + z^2)
        @test isapprox(QEDbase.getMagnitude(mom_onshell), sqrt(x^2 + y^2 + z^2))
    end

    @testset "mass consistence" for mom_on in [mom_onshell, mom_zero]
        @test QEDbase.getInvariantMass2(mom_on) == QEDbase.getMass2(mom_on)
        @test QEDbase.getInvariantMass(mom_on) == QEDbase.getMass(mom_on)
        @test isapprox(
            QEDbase.getInvariantMass(mom_on), sqrt(QEDbase.getInvariantMass2(mom_on))
        )
    end

    @testset "mass value" begin
        @test isapprox(QEDbase.getInvariantMass2(mom_onshell), E^2 - (x^2 + y^2 + z^2))
        @test isapprox(QEDbase.getInvariantMass(mom_onshell), sqrt(E^2 - (x^2 + y^2 + z^2)))

        @test isapprox(QEDbase.getInvariantMass(mom_onshell), mass)
        @test isapprox(QEDbase.getInvariantMass(mom_offshell), -mass)
        @test isapprox(QEDbase.getInvariantMass(mom_zero), 0.0)
    end

    @testset "momentum components" begin
        @test QEDbase.getE(mom_onshell) == E
        @test QEDbase.getEnergy(mom_onshell) == QEDbase.getE(mom_onshell)
        @test QEDbase.getPx(mom_onshell) == x
        @test QEDbase.getPy(mom_onshell) == y
        @test QEDbase.getPz(mom_onshell) == z

        @test isapprox(QEDbase.getBeta(mom_onshell), sqrt(x^2 + y^2 + z^2) / E)
        @test isapprox(
            QEDbase.getGamma(mom_onshell), 1 / sqrt(1.0 - QEDbase.getBeta(mom_onshell)^2)
        )

        @test QEDbase.getE(mom_zero) == 0.0
        @test QEDbase.getEnergy(mom_zero) == 0.0
        @test QEDbase.getPx(mom_zero) == 0.0
        @test QEDbase.getPy(mom_zero) == 0.0
        @test QEDbase.getPz(mom_zero) == 0.0

        @test isapprox(QEDbase.getBeta(mom_zero), 0.0)
        @test isapprox(QEDbase.getGamma(mom_zero), 1.0)
    end

    @testset "transverse coordinates" for mom_on in [mom_onshell, mom_zero]
        @test QEDbase.getTransverseMomentum2(mom_on) == QEDbase.getPt2(mom_on)
        @test QEDbase.getTransverseMomentum2(mom_on) == QEDbase.getPerp2(mom_on)
        @test QEDbase.getTransverseMomentum(mom_on) == QEDbase.getPt(mom_on)
        @test QEDbase.getTransverseMomentum(mom_on) == QEDbase.getPerp(mom_on)

        @test isapprox(QEDbase.getPt(mom_on), sqrt(QEDbase.getPt2(mom_on)))

        @test QEDbase.getTransverseMass2(mom_on) == QEDbase.getMt2(mom_on)
        @test QEDbase.getTransverseMass(mom_on) == QEDbase.getMt(mom_on)
    end

    @testset "transverse coordiantes value" begin
        @test isapprox(QEDbase.getTransverseMomentum2(mom_onshell), x^2 + y^2)
        @test isapprox(QEDbase.getTransverseMomentum(mom_onshell), sqrt(x^2 + y^2))
        @test isapprox(QEDbase.getTransverseMass2(mom_onshell), E^2 - z^2)
        @test isapprox(QEDbase.getTransverseMass(mom_onshell), sqrt(E^2 - z^2))
        @test isapprox(QEDbase.getMt(mom_offshell), -mass)
        @test isapprox(QEDbase.getRapidity(mom_onshell), 0.5 * log((E + z) / (E - z)))

        @test isapprox(QEDbase.getTransverseMomentum2(mom_zero), 0.0)
        @test isapprox(QEDbase.getTransverseMomentum(mom_zero), 0.0)
        @test isapprox(QEDbase.getTransverseMass2(mom_zero), 0.0)
        @test isapprox(QEDbase.getTransverseMass(mom_zero), 0.0)
        @test isapprox(QEDbase.getMt(mom_zero), 0.0)
    end

    @testset "spherical coordiantes consistence" for mom_on in [mom_onshell, mom_zero]
        @test QEDbase.getRho2(mom_on) == QEDbase.getMagnitude2(mom_on)
        @test QEDbase.getRho(mom_on) == QEDbase.getMagnitude(mom_on)

        @test isapprox(QEDbase.getCosTheta(mom_on), cos(QEDbase.getTheta(mom_on)))
        @test isapprox(QEDbase.getCosPhi(mom_on), cos(QEDbase.getPhi(mom_on)))
        @test isapprox(QEDbase.getSinPhi(mom_on), sin(QEDbase.getPhi(mom_on)))
    end

    @testset "spherical coordiantes values" begin
        @test isapprox(QEDbase.getTheta(mom_onshell), atan(QEDbase.getPt(mom_onshell), z))
        @test isapprox(QEDbase.getTheta(mom_zero), 0.0)

        @test isapprox(QEDbase.getPhi(mom_onshell), atan(y, x))
        @test isapprox(QEDbase.getPhi(mom_zero), 0.0)
    end

    @testset "light-cone coordiantes" begin
        @test isapprox(QEDbase.getPlus(mom_onshell), 0.5 * (E + z))
        @test isapprox(QEDbase.getMinus(mom_onshell), 0.5 * (E - z))

        @test isapprox(QEDbase.getPlus(mom_zero), 0.0)
        @test isapprox(QEDbase.getMinus(mom_zero), 0.0)
    end
end # FourMomentum getter

function test_get_set(rng, setter, getter; value=rand(rng))
    x, y, z = rand(rng, 3)
    mass = rand(rng)
    E = sqrt(x^2 + y^2 + z^2 + mass^2)
    mom = MFourMomentum(E, x, y, z)
    setter(mom, value)
    return isapprox(getter(mom), value)
end

@testset "FourMomentum setter" begin
    rng = MersenneTwister(123456)

    @testset "Momentum components" begin
        @test test_get_set(rng, QEDbase.setE!, QEDbase.getE)
        @test test_get_set(rng, QEDbase.setEnergy!, QEDbase.getE)
        @test test_get_set(rng, QEDbase.setPx!, QEDbase.getPx)
        @test test_get_set(rng, QEDbase.setPy!, QEDbase.getPy)
        @test test_get_set(rng, QEDbase.setPz!, QEDbase.getPz)
    end

    @testset "spherical coordiantes" begin
        @test test_get_set(rng, QEDbase.setTheta!, QEDbase.getTheta)
        @test test_get_set(rng, QEDbase.setTheta!, QEDbase.getTheta, value=0.0)
        @test test_get_set(rng, QEDbase.setCosTheta!, QEDbase.getCosTheta)
        @test test_get_set(rng, QEDbase.setCosTheta!, QEDbase.getCosTheta, value=1.0)
        @test test_get_set(rng, QEDbase.setPhi!, QEDbase.getPhi)
        @test test_get_set(rng, QEDbase.setPhi!, QEDbase.getPhi, value=0.0)
        @test test_get_set(rng, QEDbase.setRho!, QEDbase.getRho)
        @test test_get_set(rng, QEDbase.setRho!, QEDbase.getRho, value=0.0)
    end

    @testset "light-cone coordiantes" begin
        @test test_get_set(rng, QEDbase.setPlus!, QEDbase.getPlus)
        @test test_get_set(rng, QEDbase.setPlus!, QEDbase.getPlus, value=0.0)
        @test test_get_set(rng, QEDbase.setMinus!, QEDbase.getMinus)
        @test test_get_set(rng, QEDbase.setMinus!, QEDbase.getMinus, value=0.0)
    end

    @testset "transverse coordinates" begin
        @test test_get_set(
            rng, QEDbase.setTransverseMomentum!, QEDbase.getTransverseMomentum
        )
        @test test_get_set(
            rng, QEDbase.setTransverseMomentum!, QEDbase.getTransverseMomentum, value=0.0
        )
        @test test_get_set(rng, QEDbase.setPerp!, QEDbase.getTransverseMomentum)
        @test test_get_set(rng, QEDbase.setPt!, QEDbase.getTransverseMomentum)
        @test test_get_set(rng, QEDbase.setTransverseMass!, QEDbase.getTransverseMass)
        @test test_get_set(
            rng, QEDbase.setTransverseMass!, QEDbase.getTransverseMass, value=0.0
        )
        @test test_get_set(rng, QEDbase.setMt!, QEDbase.getTransverseMass)
        @test test_get_set(rng, QEDbase.setRapidity!, QEDbase.getRapidity)
        @test test_get_set(rng, QEDbase.setRapidity!, QEDbase.getRapidity, value=0.0)
    end
end # FourMomentum setter

const SCALE = 10.0 .^ [-9, 0, 5]
const M_MASSIVE = 1.0
const M_MASSLESS = 0.0

const M_ABSERR = 0.01
const M_RELERR = 0.0001

@testset "isonshell" begin
    rng = MersenneTwister(42)
    x_base, y_base, z_base = rand(rng, 3)

    @testset "correct onshell" begin
        @testset "($x_scale, $y_scale, $z_scale)" for (x_scale, y_scale, z_scale) in
                                                      Iterators.product(SCALE, SCALE, SCALE)
            x, y, z = x_base * x_scale, y_base * y_scale, z_base * z_scale
            E_massless = sqrt(x^2 + y^2 + z^2 + M_MASSLESS^2)
            E_massive = sqrt(x^2 + y^2 + z^2 + M_MASSIVE^2)
            mom_massless = SFourMomentum(E_massless, x, y, z)
            mom_massive = SFourMomentum(E_massive, x, y, z)
            @test QEDbase.isonshell(mom_massless, M_MASSLESS)
            @test QEDbase.isonshell(mom_massive, M_MASSIVE)

            @test QEDbase.assert_onshell(mom_massless, M_MASSLESS) == nothing
            @test QEDbase.assert_onshell(mom_massive, M_MASSIVE) == nothing
        end
    end

    @testset "correct not onshell" begin
        @testset "$x_scale, $y_scale, $z_scale" for (x_scale, y_scale, z_scale) in
                                                    Iterators.product(SCALE, SCALE, SCALE)
            x, y, z = x_base * x_scale, y_base * y_scale, z_base * z_scale
            m_err = min(M_ABSERR, M_RELERR * sum([x, y, z]) / 3.0) # mass error is M_RELERR of the mean of the components
            # but has at most the value M_ABSERR

            E_massless = sqrt(x^2 + y^2 + z^2 + (M_MASSLESS + m_err)^2)
            E_massive = sqrt(x^2 + y^2 + z^2 + (M_MASSIVE + m_err)^2)
            mom_massless = SFourMomentum(E_massless, x, y, z)
            mom_massive = SFourMomentum(E_massive, x, y, z)

            @test !QEDbase.isonshell(mom_massless, M_MASSLESS)
            @test !QEDbase.isonshell(mom_massive, M_MASSIVE)

            @test_throws QEDbase.OnshellError QEDbase.assert_onshell(
                mom_massless, M_MASSLESS
            )
            @test_throws QEDbase.OnshellError QEDbase.assert_onshell(mom_massive, M_MASSIVE)
        end
    end
end

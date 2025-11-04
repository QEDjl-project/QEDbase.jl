using QEDbase
using QEDbase.Mocks
using Random

lorentz_getter = [
    getT,
    getX,
    getY,
    getZ,
    getMagnitude2,
    getMag2,
    getMagnitude,
    getMag,
    getInvariantMass2,
    getMass2,
    getInvariantMass,
    getMass,
    getE,
    getEnergy,
    getPx,
    getPy,
    getPz,
    getBeta,
    getGamma,
    getTransverseMomentum2,
    getPt2,
    getPerp2,
    getTransverseMomentum,
    getPt,
    getPerp,
    getTransverseMass2,
    getMt2,
    getTransverseMass,
    getMt,
    getRapidity,
    getRho2,
    getRho,
    getTheta,
    getCosTheta,
    getPhi,
    getCosPhi,
    getSinPhi,
    getPlus,
    getMinus,
]

lorentz_setter = [
    setE!,
    setEnergy!,
    setPx!,
    setPy!,
    setPz!,
    setTheta!,
    setCosTheta!,
    setRho!,
    setPhi!,
    setPlus!,
    setMinus!,
    setTransverseMomentum!,
    setPerp!,
    setPt!,
    setTransverseMass!,
    setMt!,
    setRapidity!,
]

@testset "LorentzVectorInterface" begin
    @testset "CustomType" begin
        @test hasmethod(minkowski_dot, Tuple{MockMomentum, MockMomentum})

        for fun in lorentz_getter
            @test hasmethod(fun, Tuple{MockMomentum})
        end
    end

    @testset "MutableCustomType" begin
        for fun in lorentz_setter
            @test hasmethod(fun, Tuple{MockMomentumMutable, <:Union{}})
        end
    end
end # LorentzVectorInterface

RNG = Xoshiro(161)
DTYPES = (Float16, Float32, Float64)

@testset "accessors" begin
    @testset "$dtype" for dtype in DTYPES
        X, Y, Z = rand(RNG, dtype, 3)
        M = rand(RNG, dtype)
        E = sqrt(X^2 + Y^2 + Z^2 + M^2) # ensure timelike coordinates


        TEST_MOM = MockMomentum(E, X, Y, Z)

        @testset "mass" begin
            @test isapprox(getInvariantMass2(TEST_MOM), E^2 - X^2 - Y^2 - Z^2)
            @test isapprox(getMass2(TEST_MOM), E^2 - X^2 - Y^2 - Z^2)
            @test isapprox(getInvariantMass(TEST_MOM), sqrt(E^2 - X^2 - Y^2 - Z^2))
            @test isapprox(getMass(TEST_MOM), sqrt(E^2 - X^2 - Y^2 - Z^2))
        end

        @testset "cartesian" begin
            @test isapprox(getT(TEST_MOM), E)
            @test isapprox(getX(TEST_MOM), X)
            @test isapprox(getY(TEST_MOM), Y)
            @test isapprox(getZ(TEST_MOM), Z)

            @test isapprox(getE(TEST_MOM), E)
            @test isapprox(getEnergy(TEST_MOM), E)
            @test isapprox(getPx(TEST_MOM), X)
            @test isapprox(getPy(TEST_MOM), Y)
            @test isapprox(getPz(TEST_MOM), Z)
        end

        @testset "lorentz factors" begin
            @test isapprox(getBeta(TEST_MOM), sqrt(X^2 + Y^2 + Z^2) / E)
            @test isapprox(getGamma(TEST_MOM), E / M)
        end

        @testset "spherical" begin
            @test isapprox(getMagnitude2(TEST_MOM), X^2 + Y^2 + Z^2)
            @test isapprox(getMag2(TEST_MOM), X^2 + Y^2 + Z^2)
            @test isapprox(getRho2(TEST_MOM), X^2 + Y^2 + Z^2)
            @test isapprox(getMagnitude(TEST_MOM), sqrt(X^2 + Y^2 + Z^2))
            @test isapprox(getMag(TEST_MOM), sqrt(X^2 + Y^2 + Z^2))
            @test isapprox(getRho(TEST_MOM), sqrt(X^2 + Y^2 + Z^2))

            @test isapprox(getTheta(TEST_MOM), atan(sqrt(X^2 + Y^2), Z))
            @test isapprox(getCosTheta(TEST_MOM), Z / sqrt(X^2 + Y^2 + Z^2))
            @test isapprox(getPhi(TEST_MOM), atan(Y, X))
            @test isapprox(getCosPhi(TEST_MOM), X / sqrt(X^2 + Y^2))
            @test isapprox(getSinPhi(TEST_MOM), Y / sqrt(X^2 + Y^2))
        end

        @testset "transverse" begin
            @test isapprox(getTransverseMomentum2(TEST_MOM), X^2 + Y^2)
            @test isapprox(getPt2(TEST_MOM), X^2 + Y^2)
            @test isapprox(getPerp2(TEST_MOM), X^2 + Y^2)
            @test isapprox(getTransverseMomentum(TEST_MOM), sqrt(X^2 + Y^2))
            @test isapprox(getPt(TEST_MOM), sqrt(X^2 + Y^2))
            @test isapprox(getPerp(TEST_MOM), sqrt(X^2 + Y^2))

            @test isapprox(getTransverseMass2(TEST_MOM), E^2 - Z^2)
            @test isapprox(getMt2(TEST_MOM), E^2 - Z^2)
            @test isapprox(getTransverseMass(TEST_MOM), sqrt(E^2 - Z^2))
            @test isapprox(getMt(TEST_MOM), sqrt(E^2 - Z^2))

            @test isapprox(getRapidity(TEST_MOM), log((E + Z) / (E - Z)) / 2)
        end

        @testset "light cone" begin
            @test isapprox(getPlus(TEST_MOM), (E + Z) / 2)
            @test isapprox(getMinus(TEST_MOM), (E - Z) / 2)
        end

        @testset "type stability" begin
            @testset "$fun" for fun in lorentz_getter
                @test fun(TEST_MOM) isa dtype
            end
        end
    end
end

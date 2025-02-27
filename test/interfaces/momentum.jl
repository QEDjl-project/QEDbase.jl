using QEDbase
using QEDbase.Mocks

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
        @test hasmethod(minkowski_dot, Tuple{MockMomentum,MockMomentum})

        for fun in lorentz_getter
            @test hasmethod(fun, Tuple{MockMomentum})
        end
    end

    @testset "MutableCustomType" begin
        for fun in lorentz_setter
            @test hasmethod(fun, Tuple{MockMomentumMutable,<:Union{}})
        end
    end
end # LorentzVectorInterface

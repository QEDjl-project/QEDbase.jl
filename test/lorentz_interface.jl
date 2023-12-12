using QEDbase

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
        struct CustomType{T} end

        function QEDbase.getT(lv::CustomType) end
        function QEDbase.getX(lv::CustomType) end
        function QEDbase.getY(lv::CustomType) end
        function QEDbase.getZ(lv::CustomType) end

        QEDbase.register_LorentzVectorLike(CustomType)

        @test hasmethod(minkowski_dot, Tuple{CustomType,CustomType})

        for fun in lorentz_getter
            @test hasmethod(fun, Tuple{CustomType})
        end
    end

    @testset "MutableCustomType" begin
        mutable struct MutableCustomType{T} end

        function QEDbase.getT(lv::MutableCustomType) end
        function QEDbase.getX(lv::MutableCustomType) end
        function QEDbase.getY(lv::MutableCustomType) end
        function QEDbase.getZ(lv::MutableCustomType) end

        function QEDbase.setT!(lv::MutableCustomType, value::T) where {T} end
        function QEDbase.setX!(lv::MutableCustomType, value::T) where {T} end
        function QEDbase.setY!(lv::MutableCustomType, value::T) where {T} end
        function QEDbase.setZ!(lv::MutableCustomType, value::T) where {T} end

        QEDbase.register_LorentzVectorLike(MutableCustomType)

        for fun in lorentz_setter
            @test hasmethod(fun, Tuple{MutableCustomType,<:Union{}})
        end
    end
end # LorentzVectorInterface

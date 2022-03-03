
lorentz_getter = [
    getT,getX,getY,getZ,
    getMagnitude2, getMag2, getMag, 
    getInvariantMass2, getMass2, getInvariantMass, getMass,
    getE, getPx, getPy, getPz,
    getBeta, getGamma,
    getTransverseMomentum2, getPt2, getPerp2, getTransverseMomentum, getPt, getPerp,
    getTransverseMass2, getMt2, getTransverseMass, getMt, 
    getRapidity,
    getRho2,getRho,
    getTheta,getCosTheta,
    getPhi,getCosPhi,getSinPhi,
    getPlus,getMinus,
]

lorentz_setter = [
    setE!,setPx!,setPy!,setPz!,
    setTheta!,setCosTheta!,setRho!,
    setPlus!,setMinus!,
    setTransversMomentum!,setPerp!,setPt!,
    setTransverseMass!,setMt!,
    setRapidity!
]

@testset "LorentzVectorInterface" begin

    @testset "CustomType" begin
        struct CustomType{T<:Real}
            t::T
            x::T
            y::T
            z::T
        end
        
        @inline QEDbase.getT(lv::CustomType) = lv.t
        @inline QEDbase.getX(lv::CustomType) = lv.x
        @inline QEDbase.getY(lv::CustomType) = lv.y
        @inline QEDbase.getZ(lv::CustomType) = lv.z

        QEDbase.register_LorentzVectorLike(CustomType)

        @test hasmethod(minkowski_dot,Tuple{CustomType,CustomType})
        
        for fun in lorentz_getter
            @test hasmethod(fun,Tuple{CustomType})
        end
    end

    @testset "MutableCustomType" begin
        struct MutableCustomType{T<:Real}
            t::T
            x::T
            y::T
            z::T
        end
        
        @inline QEDbase.getT(lv::MutableCustomType) = lv.t
        @inline QEDbase.getX(lv::MutableCustomType) = lv.x
        @inline QEDbase.getY(lv::MutableCustomType) = lv.y
        @inline QEDbase.getZ(lv::MutableCustomType) = lv.z


        function QEDbase.setT!(lv::MutableCustomType,value::T) where {T<:Real}
            lv.t = value
        end

        function QEDbase.setX!(lv::MutableCustomType,value::T) where {T<:Real}
            lv.x = value
        end

        function QEDbase.setY!(lv::MutableCustomType,value::T) where {T<:Real}
            lv.y = value
        end

        function QEDbase.setZ!(lv::MutableCustomType,value::T) where {T<:Real}
            lv.z = value
        end


        QEDbase.register_LorentzVectorLike(MutableCustomType)

        for fun in lorentz_setter
            @test hasmethod(fun,Tuple{MutableCustomType, Union{}})
        end
    end

end # LorentzVectorInterface
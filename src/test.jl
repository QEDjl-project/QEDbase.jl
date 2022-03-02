
using QEDbase
using StaticArrays
using BenchmarkTools

struct CustomType<:FieldVector{4,Float64}
    t::Float64
    x::Float64
    y::Float64
    z::Float64
end

QEDbase.getT(lv::CustomType) = lv.t
QEDbase.getX(lv::CustomType) = lv.x
QEDbase.getY(lv::CustomType) = lv.y
QEDbase.getZ(lv::CustomType) = lv.z


#QEDbase.LorentzVectorStyle(::CustomType) = QEDbase.IsLorentzVectorLike()

QEDbase.register_LorentzVectorLike(CustomType)

#hasmethod(QEDbase.getT,Tuple{CustomType})

a = CustomType(rand(4)...)
b = CustomType(rand(4)...)




mdot(a,b)

@benchmark mdot($a,$b)

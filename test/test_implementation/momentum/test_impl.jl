abstract type AbstractTestMomentum{T} end
function (::Type{MOM})(
    coords::VECTYPE
) where {MOM<:AbstractTestMomentum,V<:AbstractVector,VECTYPE<:Union{Tuple,V}}
    return MOM(coords...)
end
Base.eltype(::Type{MOM_TYPE}) where {T,MOM_TYPE<:AbstractTestMomentum{T}} = T
Base.eltype(mom::MOM_TYPE) where {T,MOM_TYPE<:AbstractTestMomentum{T}} = T

Base.zero(mom_type::Type{<:AbstractTestMomentum}) = mom_type(zero(eltype(mom_type), 4))
Base.one(mom_type::Type{<:AbstractTestMomentum}) = mom_type(ones(eltype(mom_type), 4))

struct TestMomentum{T} <: AbstractTestMomentum{T}
    t::T
    x::T
    y::T
    z::T
end

QEDbase.getT(lv::TestMomentum) = lv.t
QEDbase.getX(lv::TestMomentum) = lv.x
QEDbase.getY(lv::TestMomentum) = lv.y
QEDbase.getZ(lv::TestMomentum) = lv.z

QEDbase.register_LorentzVectorLike(TestMomentum)

mutable struct TestMomentumMutable{T} <: AbstractTestMomentum{T}
    t::T
    x::T
    y::T
    z::T
end

QEDbase.getT(lv::TestMomentumMutable) = lv.t
QEDbase.getX(lv::TestMomentumMutable) = lv.x
QEDbase.getY(lv::TestMomentumMutable) = lv.y
QEDbase.getZ(lv::TestMomentumMutable) = lv.z

QEDbase.setT!(lv::TestMomentumMutable, t) = (lv.t = t)
QEDbase.setX!(lv::TestMomentumMutable, x) = (lv.x = x)
QEDbase.setY!(lv::TestMomentumMutable, y) = (lv.y = y)
QEDbase.setZ!(lv::TestMomentumMutable, z) = (lv.z = z)

QEDbase.register_LorentzVectorLike(TestMomentumMutable)

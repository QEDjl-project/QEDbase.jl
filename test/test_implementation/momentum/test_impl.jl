abstract type AbstractTestMomentum{T} <: AbstractFourMomentum end

#StaticArrays.similar_type(::Type{A},::Type{T},::Size{S}) where {A<:AbstractTestMomentum,T,S} = A{T}
#StaticArrays.similar_type(::Type{A},::Type{T}) where {A<:AbstractTestMomentum,T} = A{T}

#=
function (::Type{MOM})(
    coords::VECTYPE
) where {MOM<:AbstractTestMomentum,V<:AbstractVector,VECTYPE<:Union{Tuple,V}}
    return MOM(coords...)
end
=#

struct TestMomentum{T} <: AbstractTestMomentum{T}
    E::T
    px::T
    py::T
    pz::T
end

function StaticArrays.similar_type(
    ::Type{A}, ::Type{T}, ::Size{S}
) where {A<:TestMomentum,T,S}
    return TestMomentum{T}
end

QEDbase.getT(lv::TestMomentum) = lv.E
QEDbase.getX(lv::TestMomentum) = lv.px
QEDbase.getY(lv::TestMomentum) = lv.py
QEDbase.getZ(lv::TestMomentum) = lv.pz

QEDbase.register_LorentzVectorLike(TestMomentum)

mutable struct TestMomentumMutable{T} <: AbstractTestMomentum{T}
    E::T
    px::T
    py::T
    pz::T
end

function StaticArrays.similar_type(
    ::Type{A}, ::Type{T}, ::Size{S}
) where {A<:TestMomentumMutable,T,S}
    return TestMomentumMutable{T}
end

QEDbase.getT(lv::TestMomentumMutable) = lv.E
QEDbase.getX(lv::TestMomentumMutable) = lv.px
QEDbase.getY(lv::TestMomentumMutable) = lv.py
QEDbase.getZ(lv::TestMomentumMutable) = lv.pz

QEDbase.setT!(lv::TestMomentumMutable, E) = (lv.E = E)
QEDbase.setX!(lv::TestMomentumMutable, px) = (lv.px = px)
QEDbase.setY!(lv::TestMomentumMutable, py) = (lv.py = py)
QEDbase.setZ!(lv::TestMomentumMutable, pz) = (lv.pz = pz)

QEDbase.register_LorentzVectorLike(TestMomentumMutable)

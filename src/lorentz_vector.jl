"""
LorentzVectors
"""

#######
#
# Abstract types
#
#######
"""
$(TYPEDEF)

Abstract type to model generic Lorentz vectors, i.e. elements of a minkowski-like space, where the component space is arbitray.
"""
abstract type AbstractLorentzVector{T} <: FieldVector{4,T} end

#interface with dirac tensors

"""
$(TYPEDSIGNATURES)

Product of generic Lorentz vector with a Dirac tensor from the left. Basically, the multiplication is piped to the components from the Lorentz vector.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.
"""
function mul(
    DM::T, L::TL
) where {T<:Union{AbstractDiracMatrix,AbstractDiracVector},TL<:AbstractLorentzVector}
    return constructorof(TL)(DM * L[1], DM * L[2], DM * L[3], DM * L[4])
end
@inline function *(
    DM::T, L::TL
) where {T<:Union{AbstractDiracMatrix,AbstractDiracVector},TL<:AbstractLorentzVector}
    return mul(DM, L)
end

"""
$(TYPEDSIGNATURES)

Product of generic Lorentz vector with a Dirac tensor from the right. Basically, the multiplication is piped to the components from the Lorentz vector.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(
    L::TL, DM::T
) where {TL<:AbstractLorentzVector,T<:Union{AbstractDiracMatrix,AbstractDiracVector}}
    return constructorof(TL)(L[1] * DM, L[2] * DM, L[3] * DM, L[4] * DM)
end
@inline function *(
    L::TL, DM::T
) where {TL<:AbstractLorentzVector,T<:Union{AbstractDiracMatrix,AbstractDiracVector}}
    return mul(L, DM)
end

#######
#
# Concrete LorentzVector types
#
#######
"""
$(TYPEDEF)

Concrete implementation of a generic static Lorentz vector. Each manipulation of an concrete implementation which is not self-contained (i.e. produces the same Lorentz vector type) will result in this type.

# Fields
$(TYPEDFIELDS)
"""
struct SLorentzVector{T} <: AbstractLorentzVector{T}
    "`t` component"
    t::T

    "`x` component"
    x::T

    "`y` component"
    y::T

    "`z` component"
    z::T
end
SLorentzVector(t, x, y, z) = SLorentzVector(promote(t, x, y, z)...)

function similar_type(::Type{A}, ::Type{T}, ::Size{S}) where {A<:SLorentzVector,T,S}
    return SLorentzVector{T}
end

@inline getT(lv::SLorentzVector) = lv.t
@inline getX(lv::SLorentzVector) = lv.x
@inline getY(lv::SLorentzVector) = lv.y
@inline getZ(lv::SLorentzVector) = lv.z

register_LorentzVectorLike(SLorentzVector)

"""
$(TYPEDEF)

Concrete implementation of a generic mutable Lorentz vector. Each manipulation of an concrete implementation which is not self-contained (i.e. produces the same Lorentz vector type) will result in this type.

# Fields
$(TYPEDFIELDS)
"""
mutable struct MLorentzVector{T} <: AbstractLorentzVector{T}
    "`t` component"
    t::T

    "`x` component"
    x::T

    "`y` component"
    y::T

    "`z` component"
    z::T
end
MLorentzVector(t, x, y, z) = MLorentzVector(promote(t, x, y, z)...)

function similar_type(::Type{A}, ::Type{T}, ::Size{S}) where {A<:MLorentzVector,T,S}
    return MLorentzVector{T}
end

@inline getT(lv::MLorentzVector) = lv.t
@inline getX(lv::MLorentzVector) = lv.x
@inline getY(lv::MLorentzVector) = lv.y
@inline getZ(lv::MLorentzVector) = lv.z

function QEDbase.setT!(lv::MLorentzVector, value::T) where {T}
    return lv.t = value
end

function QEDbase.setX!(lv::MLorentzVector, value::T) where {T}
    return lv.x = value
end

function QEDbase.setY!(lv::MLorentzVector, value::T) where {T}
    return lv.y = value
end

function QEDbase.setZ!(lv::MLorentzVector, value::T) where {T}
    return lv.z = value
end

register_LorentzVectorLike(MLorentzVector)

function dot(p1::T1, p2::T2) where {T1<:AbstractLorentzVector,T2<:AbstractLorentzVector}
    return mdot(p1, p2)
end
@inline function *(
    p1::T1, p2::T2
) where {T1<:AbstractLorentzVector,T2<:AbstractLorentzVector}
    return dot(p1, p2)
end

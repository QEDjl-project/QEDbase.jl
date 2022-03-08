"""
SFourMomentum type

"""

abstract type AbstractFourMomentum <: AbstractLorentzVector{Float64} end

#######
#
# Concrete SFourMomentum type
#
#######
"""
$(TYPEDEF)

Builds a static LorentzVector with real components used to statically model the four-momentum of a particle or field.

# Fields
$(TYPEDFIELDS)
"""
struct SFourMomentum <: AbstractFourMomentum

    "Time component"
    t::Float64

    "`x` component"
    x::Float64

    "`y` component"
    y::Float64

    "`z` component"
    z::Float64
end


"""
$(SIGNATURES)

The interface transforms each number-like input to float64:

$(TYPEDSIGNATURES)
"""
SFourMomentum(t::T, x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} = SFourMomentum(float(t), x, y, z)


similar_type(::Type{A},::Type{T},::Size{S}) where {A<: SFourMomentum,T<:Real,S} = SFourMomentum
similar_type(::Type{A},::Type{T},::Size{S}) where {A<: SFourMomentum,T,S} = SLorentzVector{T}


@inline getT(p::SFourMomentum) = p.t
@inline getX(p::SFourMomentum) = p.x
@inline getY(p::SFourMomentum) = p.y
@inline getZ(p::SFourMomentum) = p.z

register_LorentzVectorLike(SFourMomentum)

#######
#
# Concrete MFourMomentum type
#
#######
"""
$(TYPEDEF)

Builds a mutable LorentzVector with real components used to statically model the four-momentum of a particle or field.

# Fields
$(TYPEDFIELDS)
"""
mutable struct MFourMomentum <: AbstractFourMomentum

    "Time component"
    t::Float64

    "`x` component"
    x::Float64

    "`y` component"
    y::Float64

    "`z` component"
    z::Float64
end


"""
$(SIGNATURES)

The interface transforms each number-like input to float64:

$(TYPEDSIGNATURES)
"""
MFourMomentum(t::T, x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} = MFourMomentum(float(t), x, y, z)


similar_type(::Type{A},::Type{T},::Size{S}) where {A<: MFourMomentum,T<:Real,S} = MFourMomentum
similar_type(::Type{A},::Type{T},::Size{S}) where {A<: MFourMomentum,T,S} = MLorentzVector{T}


@inline getT(p::MFourMomentum) = p.t
@inline getX(p::MFourMomentum) = p.x
@inline getY(p::MFourMomentum) = p.y
@inline getZ(p::MFourMomentum) = p.z




function QEDbase.setT!(lv::MFourMomentum,value::Float64)
    lv.t = value
end

function QEDbase.setX!(lv::MFourMomentum,value::Float64)
    lv.x = value
end

function QEDbase.setY!(lv::MFourMomentum,value::Float64)
    lv.y = value
end

function QEDbase.setZ!(lv::MFourMomentum,value::Float64)
    lv.z = value
end


register_LorentzVectorLike(MFourMomentum)



#######
#
# Utility functions on FourMomenta
#
#######
function isonshell(P::TM,m::T) where {TM<:AbstractFourMomentum,T<:Real}
    isapprox(getMass2(P),m^2)
end

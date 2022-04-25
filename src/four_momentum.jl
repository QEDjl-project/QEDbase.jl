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

Builds a static LorentzVectorLike with real components used to statically model the four-momentum of a particle or field.

# Fields
$(TYPEDFIELDS)
"""
struct SFourMomentum <: AbstractFourMomentum

    "energy component"
    E::Float64

    "`x` component"
    px::Float64

    "`y` component"
    py::Float64

    "`z` component"
    pz::Float64
end



"""
$(SIGNATURES)

The interface transforms each number-like input to float64:

$(TYPEDSIGNATURES)
"""
SFourMomentum(t::T, x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} = SFourMomentum(float(t), x, y, z)


similar_type(::Type{A},::Type{T},::Size{S}) where {A<: SFourMomentum,T<:Real,S} = SFourMomentum
similar_type(::Type{A},::Type{T},::Size{S}) where {A<: SFourMomentum,T,S} = SLorentzVector{T}


@inline getT(p::SFourMomentum) = p.E
@inline getX(p::SFourMomentum) = p.px
@inline getY(p::SFourMomentum) = p.py
@inline getZ(p::SFourMomentum) = p.pz

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

    "energy component"
    E::Float64

    "`x` component"
    px::Float64

    "`y` component"
    py::Float64

    "`z` component"
    pz::Float64
end


"""
$(SIGNATURES)

The interface transforms each number-like input to float64:

$(TYPEDSIGNATURES)
"""
MFourMomentum(t::T, x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} = MFourMomentum(float(t), x, y, z)


similar_type(::Type{A},::Type{T},::Size{S}) where {A<: MFourMomentum,T<:Real,S} = MFourMomentum
similar_type(::Type{A},::Type{T},::Size{S}) where {A<: MFourMomentum,T,S} = MLorentzVector{T}


@inline getT(p::MFourMomentum) = p.E
@inline getX(p::MFourMomentum) = p.px
@inline getY(p::MFourMomentum) = p.py
@inline getZ(p::MFourMomentum) = p.pz




function QEDbase.setT!(lv::MFourMomentum,value::Float64)
    lv.E = value
end

function QEDbase.setX!(lv::MFourMomentum,value::Float64)
    lv.px = value
end

function QEDbase.setY!(lv::MFourMomentum,value::Float64)
    lv.py = value
end

function QEDbase.setZ!(lv::MFourMomentum,value::Float64)
    lv.pz = value
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

function Base.getproperty(P::TM,sym::Symbol) where {TM<:AbstractFourMomentum}
    if sym==:t
        return P.E
    elseif sym==:x
        return P.px
    elseif sym==:y
        return P.py
    elseif sym==:z
        return P.pz
    else
        return getfield(P,sym)
    end
end
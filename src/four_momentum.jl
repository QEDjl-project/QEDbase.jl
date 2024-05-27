"""
    AbstractFourMomentum

Abstract base type for four-momentas, representing one energy and three spacial components.

Also see: [`SFourMomentum`](@ref)
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
function SFourMomentum(t::T, x::T, y::T, z::T) where {T<:Union{Integer,Rational,Irrational}}
    return SFourMomentum(float(t), x, y, z)
end

function similar_type(::Type{A}, ::Type{T}, ::Size{S}) where {A<:SFourMomentum,T<:Real,S}
    return SFourMomentum
end
function similar_type(::Type{A}, ::Type{T}, ::Size{S}) where {A<:SFourMomentum,T,S}
    return SLorentzVector{T}
end

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
function MFourMomentum(t::T, x::T, y::T, z::T) where {T<:Union{Integer,Rational,Irrational}}
    return MFourMomentum(float(t), x, y, z)
end

function similar_type(::Type{A}, ::Type{T}, ::Size{S}) where {A<:MFourMomentum,T<:Real,S}
    return MFourMomentum
end
function similar_type(::Type{A}, ::Type{T}, ::Size{S}) where {A<:MFourMomentum,T,S}
    return MLorentzVector{T}
end

@inline getT(p::MFourMomentum) = p.E
@inline getX(p::MFourMomentum) = p.px
@inline getY(p::MFourMomentum) = p.py
@inline getZ(p::MFourMomentum) = p.pz

function QEDbase.setT!(lv::MFourMomentum, value::Float64)
    return lv.E = value
end

function QEDbase.setX!(lv::MFourMomentum, value::Float64)
    return lv.px = value
end

function QEDbase.setY!(lv::MFourMomentum, value::Float64)
    return lv.py = value
end

function QEDbase.setZ!(lv::MFourMomentum, value::Float64)
    return lv.pz = value
end

register_LorentzVectorLike(MFourMomentum)

function Base.getproperty(P::TM, sym::Symbol) where {TM<:AbstractFourMomentum}
    if sym == :t
        return P.E
    elseif sym == :x
        return P.px
    elseif sym == :y
        return P.py
    elseif sym == :z
        return P.pz
    else
        return getfield(P, sym)
    end
end

#######
#
# Utility functions on FourMomenta
#
#######

function isonshell(mom::QEDbase.AbstractLorentzVector{T}) where {T<:Real}
    mag2 = getMag2(mom)
    E = getE(mom)
    return isapprox(E^2, mag2; rtol=eps(T))
end

"""
$(SIGNATURES)

On-shell check of a given four-momentum `mom` w.r.t. a given mass `mass`. 

!!! note "Precision"
    For `AbstactFourMomentum`, the element type is fixed to `Float64`, limiting the precision of comparisons between elements.
    The current implementation has been tested within the boundaries for energy scales `E` with `1e-9 <= E <= 1e5`. 
    In those bounds, the mass error, which is correctly detected as off-shell, is `1e-4` times the mean value of the components, but has at most the value `0.01`, e.g. at the high energy end.
    The energy scales correspond to `0.5 meV` for the lower bound and `50 GeV` for the upper bound.


!!! todo "FourMomenta with real entries"
    * if `AbstractFourMomentum` is updated to elementtypes `T<:Real`, the `AbstractLorentzVector` should be updated with the `AbstractFourMomentum`.
"""
function isonshell(mom::QEDbase.AbstractLorentzVector{T}, mass::Real) where {T<:Real}
    if iszero(mass)
        return isonshell(mom)
    end
    mag2 = getMag2(mom)
    E = getE(mom)
    return isapprox(E^2, (mass)^2 + mag2; atol=2 * eps(T), rtol=eps(T))
end

struct OnshellError{M,T} <: Exception
    mom::M
    mass::T
end

function Base.showerror(io::IO, e::OnshellError)
    return print(
        io,
        "OnshellError: The momentum $(e.mom) is not onshell w.r.t. the mass $(e.mass).\n mom*mom = $(e.mom*e.mom)",
    )
end

"""
$(SIGNATURES)

Assertion if a FourMomentum `mom` is on-shell w.r.t a given mass `mass`.

!!! note "See also"
    The precision of this functions is explained in [`isonshell`](@ref).
    
"""
function assert_onshell(mom::QEDbase.AbstractLorentzVector, mass::Real)
    isonshell(mom, mass) || throw(OnshellError(mom, mass))
    return nothing
end

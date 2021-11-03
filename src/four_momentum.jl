"""
FourMomentum type

"""


#######
#
# Concrete FourMomentum type
#
#######
"""
$(TYPEDEF)

Builds a LorentzVector with real components used to model the four-momentum of a particle or field.

# Fields
$(TYPEDFIELDS)
"""
struct FourMomentum <: AbstractLorentzVector{Float64}

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
FourMomentum(t::T, x::T, y::T, z::T) where {T <: Union{Integer, Rational, Irrational}} = FourMomentum(float(t), x, y, z)


similar_type(::Type{A},::Type{T},::Size{S}) where {A<: FourMomentum,T<:Real,S} = FourMomentum
similar_type(::Type{A},::Type{T},::Size{S}) where {A<: FourMomentum,T,S} = LorentzVector{T}



#######
#
# Utility functions on FourMomenta
#
#######
"""

    mass_square(p::FourMomentum)

Calculate the mass square of the given four-momentum. We use the mostly-minus metric for that, i.e. return

```math
m^2 := p_0^2 - p_1^2 -p_2^2 - p_3^2
```
"""
function mass_square(p::FourMomentum)
    dot(p,p)
end

"""

    mass(p::FourMomentum)

Calculate the mass w.r.t. a given four-momentum ``p``. This function will return a complex number if the mass square is negative, e.g. if ``p`` is the momentum of a virtual particle.
"""
function mass(p::FourMomentum)
    m2 = mass_square(p)
    if m2<0
        m2=complex(m2)
    end
    return sqrt(m2)
end

function isonshell(P::FourMomentum,m::T) where T<:Real
    isapprox(mass_square(P),m^2)
end

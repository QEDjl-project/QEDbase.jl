"""
FourPolarisation type

TODO:
- type promotion into complex fields

"""

struct FourPolarisation <: AbstractLorentzVector{ComplexF64}
    t::ComplexF64
    x::ComplexF64
    y::ComplexF64
    z::ComplexF64
end

FourPolarisation(t, x, y, z) = FourPolarisation(promote(t, x, y, z)...)

function FourPolarisation(t::T, x::T, y::T, z::T) where {T<:Number}
    return FourPolarisation(complex(t), x, y, z)
end

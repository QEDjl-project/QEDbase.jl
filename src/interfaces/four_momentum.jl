"""
    AbstractFourMomentum

Abstract base type for four-momentas, representing one energy and three spacial components.

Also see: `QEDcore.SFourMomentum`, `QEDcore.MFourMomentum`
"""
abstract type AbstractFourMomentum <: AbstractLorentzVector{Float64} end

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

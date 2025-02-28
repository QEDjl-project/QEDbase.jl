"""
    AbstractFourMomentum{T_ELEM} where {T_ELEM<:Real}

Abstract base type for four-momentas, representing one energy and three spacial components.

Also see: [`QEDcore.SFourMomentum`](@extref), [`QEDcore.MFourMomentum`](@extref)
"""
abstract type AbstractFourMomentum{T_ELEM<:Real} <: AbstractLorentzVector{T_ELEM} end

function Base.getproperty(P::AbstractFourMomentum{T}, sym::Symbol)::T where {T}
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

@inline Base.eltype(::Type{AbstractFourMomentum{T}}) where {T} = T
@inline Base.eltype(P::AbstractFourMomentum) = eltype(typeof(P))

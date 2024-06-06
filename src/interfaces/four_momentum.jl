"""
    AbstractFourMomentum

Abstract base type for four-momentas, representing one energy and three spacial components.

Also see: [`SFourMomentum`](@ref)
"""

abstract type AbstractFourMomentum <: AbstractLorentzVector{Float64} end

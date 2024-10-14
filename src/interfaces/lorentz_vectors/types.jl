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

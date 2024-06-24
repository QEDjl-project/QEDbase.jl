#######
#
# Abstract Dirac Tensor types
#
#######
"""
$(TYPEDEF)

Abstract type for Dirac vectors, e.g. four dimensional vectors from a spinor space.
"""
abstract type AbstractDiracVector{T} <: FieldVector{4,T} end

"""
$(TYPEDEF)

Abstract type for Dirac matrices, i.e. matrix representations for linear mappings from a spinor space into another.
"""
abstract type AbstractDiracMatrix{T} <: FieldMatrix{4,4,T} end

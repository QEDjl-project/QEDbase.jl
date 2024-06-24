"""
    AbstractCoordinateSystem

TBW
"""
abstract type AbstractCoordinateSystem end

"""
    AbstractFrameOfReference

TBW
"""
abstract type AbstractFrameOfReference end

"""
    AbstractPhasespaceDefinition

TBW
"""
abstract type AbstractPhasespaceDefinition end

Broadcast.broadcastable(ps_def::AbstractPhasespaceDefinition) = Ref(ps_def)

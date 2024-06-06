"""
    _as_svec(x)

Accepts a single object, an `SVector` of objects or a tuple of objects, and returns them in a single "layer" of SVector.

Useful with [`base_state`](@ref).
"""
function _as_svec end

@inline _as_svec(x) = SVector((x,))
@inline _as_svec(x::SVector{N,T}) where {N,T} = x
@inline _as_svec(x::NTuple) = SVector(x)

"""
    _as_svec(x)

Accepts a single object, an `SVector` of objects or a tuple of objects, and returns them in a single "layer" of SVector.

Useful with [`base_state`](@ref).
"""
function _as_svec end

@inline _as_svec(x) = SVector((x,))
@inline _as_svec(x::SVector{N, T}) where {N, T} = x
@inline _as_svec(x::NTuple) = SVector(x)

"""

    _split_uppercase(s::AbstractString)

Return a split of the given string delimited at the upper case letters in the string.

"""
@inline function _split_uppercase(s::AbstractString)
    return split(s, r"(?=[A-Z])")
end

"""
    _precise_sum(::Type{T}, in::NTuple{N, T})

Calculate the sum of the values in a tuple, with error correction applied (using a simple unrolled Kahan summation algorithm).

!!! note
    This relies on fast-math optimizations being turned off.
"""
@inline _precise_sum(::Type{T}, in::Tuple{}; sum = zero(T), error = zero(T)) where {T} = sum + error
@inline function _precise_sum(::Type{T}, in::Tuple{T, Vararg{T, N}}; sum = zero(T), error = zero(T)) where {N, T <: Number}
    y = in[1] - error
    t = sum + y
    z = t - sum
    error = z - y
    sum = t

    return _precise_sum(T, in[2:end]; sum = sum, error = error)
end

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

@inline _precise_sum_helper(in::Tuple{}, sum::T, error::T) where {T} = sum + error
@inline function _precise_sum_helper(in::Tuple{T, Vararg{T, N}}, sum::T, error::T) where {N, T}
    y = in[1] - error
    t = sum + y
    z = t - sum
    error = z - y
    sum = t

    return _precise_sum_helper(in[2:end], sum, error)
end


"""
    _precise_sum(in::NTuple{N, T})

Calculate the sum of the values in a tuple, with error correction applied (using a simple unrolled Kahan summation algorithm).

!!! note
    This relies on fast-math optimizations being turned off.
"""
@inline function _precise_sum(in::NTuple{N, T}) where {N, T}
    return _precise_sum_helper(in, zero(T), zero(T))
end

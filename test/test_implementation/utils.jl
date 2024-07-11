
# Check if any failed type is in the input 
_any_fail(x...) = true
_any_fail(::TestProcess, ::TestModel) = false
_any_fail(::TestProcess, ::TestModel, ::TestPhasespaceDef) = false

# unrolls all elements of a list of four-momenta into vector of coordinates
function _unroll_moms(ps_moms::AbstractVector{T}) where {T<:QEDbase.AbstractFourMomentum}
    return collect(Iterators.flatten(ps_moms))
end

function _unroll_moms(ps_moms::AbstractMatrix{T}) where {T<:QEDbase.AbstractFourMomentum}
    res = Matrix{eltype(T)}(undef, size(ps_moms, 1) * 4, size(ps_moms, 2))
    for i in 1:size(ps_moms, 2)
        res[:, i] .= _unroll_moms(view(ps_moms, :, i))
    end
    return res
end

flat_components(moms::AbstractVecOrMat) = _unroll_moms(moms)
flat_components(moms::Tuple) = Tuple(_unroll_moms([moms...]))

# collect components of four-momenta from a vector of coordinates
function __furl_moms(ps_coords::AbstractVector{T}) where {T<:Real}
    return SFourMomentum.(eachcol(reshape(ps_coords, 4, :)))
end

function _furl_moms(ps_coords::AbstractVector{T}) where {T<:Real}
    @assert length(ps_coords) % 4 == 0
    return __furl_moms(ps_coords)
end

function _furl_moms(ps_coords::AbstractMatrix{T}) where {T<:Real}
    @assert size(ps_coords, 1) % 4 == 0
    res = Matrix{SFourMomentum}(undef, Int(size(ps_coords, 1)//4), size(ps_coords, 2))
    for i in 1:size(ps_coords, 2)
        res[:, i] .= __furl_moms(view(ps_coords, :, i))
    end
    return res
end

function _furl_moms(moms::NTuple{N,Float64}) where {N}
    return Tuple(_furl_moms(Vector{Float64}([moms...])))
end

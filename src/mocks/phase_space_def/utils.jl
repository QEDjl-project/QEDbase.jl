
# collect components of four-momenta from a vector of coordinates
function __furl_moms(
    ps_coords::AbstractVector{T}, mom_type::Type{MOM_TYPE}
) where {T<:Real,MOM_TYPE<:AbstractMockMomentum}
    return mom_type.(eachcol(reshape(ps_coords, 4, :)))
end

function _furl_moms(
    ps_coords::AbstractVector{T}, mom_type::Type{MOM_TYPE}
) where {T<:Real,MOM_TYPE<:AbstractMockMomentum}
    @assert length(ps_coords) % 4 == 0
    return __furl_moms(ps_coords, mom_type)
end

function _furl_moms(
    ps_coords::AbstractMatrix{T}, mom_type::Type{MOM_TYPE}
) where {T<:Real,MOM_TYPE<:AbstractMockMomentum}
    @assert size(ps_coords, 1) % 4 == 0
    res = Matrix{mom_type}(undef, Int(size(ps_coords, 1)//4), size(ps_coords, 2))
    for i in 1:size(ps_coords, 2)
        res[:, i] .= __furl_moms(view(ps_coords, :, i), mom_type)
    end
    return res
end

function _furl_moms(
    moms::NTuple{N,T}, mom_type::Type{MOM_TYPE}
) where {N,T<:Real,MOM_TYPE<:AbstractMockMomentum}
    return Tuple(_furl_moms(Vector{T}([moms...]), mom_type))
end

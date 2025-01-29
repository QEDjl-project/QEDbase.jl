
Base.eltype(::Type{MOM_TYPE}) where {T,MOM_TYPE<:AbstractMockMomentum{T}} = T
Base.eltype(mom::MOM_TYPE) where {T,MOM_TYPE<:AbstractMockMomentum{T}} = T

Base.zero(mom_type::Type{<:AbstractMockMomentum}) = mom_type(zeros(eltype(mom_type), 4))
Base.one(mom_type::Type{<:AbstractMockMomentum}) = mom_type(ones(eltype(mom_type), 4))

Base.zero(mom::MOM_TYPE) where {MOM_TYPE<:AbstractMockMomentum} = Base.zero(MOM_TYPE)
Base.one(mom::MOM_TYPE) where {MOM_TYPE<:AbstractMockMomentum} = Base.one(MOM_TYPE)

Base.iszero(mom::AbstractMockMomentum) = (mom == zero(mom))
Base.isone(mom::AbstractMockMomentum) = (mom == one(mom))

function Base.isapprox(
    mom1::AbstractMockMomentum,
    mom2::AbstractMockMomentum;
    atol::Real=0.0,
    rtol::Real=Base.rtoldefault(Float64),
    nans::Bool=false,
    norm::Function=abs,
)
    return all(isapprox.(mom1.x, mom2.x; atol=atol, rtol=rtol, nans=nans, norm=norm)) &&
           all(isapprox.(mom1.y, mom2.y; atol=atol, rtol=rtol, nans=nans, norm=norm)) &&
           all(isapprox.(mom1.z, mom2.z; atol=atol, rtol=rtol, nans=nans, norm=norm)) &&
           all(isapprox.(mom1.t, mom2.t; atol=atol, rtol=rtol, nans=nans, norm=norm))
end

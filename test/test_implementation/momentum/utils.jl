
Base.eltype(::Type{MOM_TYPE}) where {T,MOM_TYPE<:AbstractTestMomentum{T}} = T
Base.eltype(mom::MOM_TYPE) where {T,MOM_TYPE<:AbstractTestMomentum{T}} = T

Base.zero(mom_type::Type{<:AbstractTestMomentum}) = mom_type(zeros(eltype(mom_type), 4))
Base.one(mom_type::Type{<:AbstractTestMomentum}) = mom_type(ones(eltype(mom_type), 4))

Base.zero(mom::MOM_TYPE) where {MOM_TYPE<:AbstractTestMomentum} = Base.zero(MOM_TYPE)
Base.one(mom::MOM_TYPE) where {MOM_TYPE<:AbstractTestMomentum} = Base.one(MOM_TYPE)

Base.iszero(mom::AbstractTestMomentum) = (mom == zero(mom))
Base.isone(mom::AbstractTestMomentum) = (mom == one(mom))

function Base.isapprox(
    mom1::AbstractTestMomentum,
    mom2::AbstractTestMomentum;
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

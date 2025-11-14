Base.eltype(::Type{MOM_TYPE}) where {T, MOM_TYPE <: AbstractMockMomentum{T}} = T
Base.eltype(mom::MOM_TYPE) where {T, MOM_TYPE <: AbstractMockMomentum{T}} = T

function Base.zero(mom_type::Type{T}) where {EL_T, T <: AbstractMockMomentum{EL_T}}
    return mom_type(zero(EL_T), zero(EL_T), zero(EL_T), zero(EL_T))
end
function Base.one(mom_type::Type{T}) where {EL_T, T <: AbstractMockMomentum{EL_T}}
    return mom_type(one(EL_T), one(EL_T), one(EL_T), one(EL_T))
end

# not pretty but necessary to make KA.jl/AMDGPU happy
# see https://github.com/JuliaGPU/AMDGPU.jl/issues/846
Base.:(==)(mom1::MOM_T, mom2::MOM_T) where {MOM_T <: AbstractMockMomentum} = (getE(mom1) == getE(mom2) && getX(mom1) == getX(mom2) && getY(mom1) == getY(mom2) && getZ(mom1) == getZ(mom2))

Base.zero(mom::MOM_TYPE) where {MOM_TYPE <: AbstractMockMomentum} = Base.zero(MOM_TYPE)
Base.one(mom::MOM_TYPE) where {MOM_TYPE <: AbstractMockMomentum} = Base.one(MOM_TYPE)

Base.iszero(mom::AbstractMockMomentum) = (mom == zero(mom))
Base.isone(mom::AbstractMockMomentum) = (mom == one(mom))

function Base.isapprox(
        mom1::AbstractMockMomentum,
        mom2::AbstractMockMomentum;
        atol::Real = 0.0,
        rtol::Real = Base.rtoldefault(Float64),
        nans::Bool = false,
        norm::Function = abs,
    )
    return all(isapprox.(mom1.x, mom2.x; atol = atol, rtol = rtol, nans = nans, norm = norm)) &&
        all(isapprox.(mom1.y, mom2.y; atol = atol, rtol = rtol, nans = nans, norm = norm)) &&
        all(isapprox.(mom1.z, mom2.z; atol = atol, rtol = rtol, nans = nans, norm = norm)) &&
        all(isapprox.(mom1.t, mom2.t; atol = atol, rtol = rtol, nans = nans, norm = norm))
end

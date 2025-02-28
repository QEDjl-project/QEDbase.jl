"""
    momentum_type(part::Type{AbstractParticleStateful})

Return the type of the particle's momentum.
"""
@inline momentum_type(::Type{<:AbstractParticleStateful{D,S,E}}) where {D,S,E} = E

"""
    momentum_type(part::AbstractParticleStateful)

Return the type of the particle's momentum.
"""
@inline momentum_type(ps::AbstractParticleStateful) = momentum_type(typeof(ps))

"""
    momentum_eltype(part::Type{AbstractParticleStateful})

Return the eltype of the particle's momentum type. Short for `eltype(momentum_type(ps))`.
"""
@inline momentum_eltype(::Type{<:AbstractParticleStateful{D,S,E}}) where {D,S,E} = eltype(E)

"""
    momentum_eltype(part::AbstractParticleStateful)

Return the eltype of the particle's momentum type. Short for `eltype(momentum_type(ps))`.
"""
@inline momentum_eltype(ps::AbstractParticleStateful) = momentum_eltype(typeof(ps))

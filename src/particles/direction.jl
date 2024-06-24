"""
Abstract base type for the directions of particles in the context of processes, i.e. either they are *incoming* or *outgoing*. Subtypes of this are mostly used for dispatch.
"""
abstract type ParticleDirection end
Base.broadcastable(dir::ParticleDirection) = Ref(dir)

"""
    is_incoming(dir::ParticleDirection)
    is_incoming(particle::AbstractParticleStateful)

Convenience function that returns true for [`Incoming`](@ref) and incoming [`AbstractParticleStateful`](@ref) and false otherwise.
"""
function is_incoming end

"""
    is_outgoing(dir::ParticleDirection)
    is_outgoing(particle::AbstractParticleStateful)

Convenience function that returns true for [`Outgoing`](@ref) and outgoing [`AbstractParticleStateful`](@ref) and false otherwise.
"""
function is_outgoing end

"""
    Incoming <: ParticleDirection

Concrete implementation of a [`ParticleDirection`](@ref) to indicate that a particle is *incoming* in the context of a given process. Mostly used for dispatch.

```jldoctest
julia> using QEDbase

julia> Incoming()
incoming
```

!!! note "ParticleDirection Interface"
    Besides being a subtype of [`ParticleDirection`](@ref), `Incoming` has

    ```julia
    is_incoming(::Incoming) = true
    is_outgoing(::Incoming) = false
    ```
"""
struct Incoming <: ParticleDirection end
is_incoming(::Incoming) = true
is_outgoing(::Incoming) = false
Base.show(io::IO, ::Incoming) = print(io, "incoming")

"""
    Outgoing <: ParticleDirection

Concrete implementation of a [`ParticleDirection`](@ref) to indicate that a particle is *outgoing* in the context of a given process. Mostly used for dispatch.

```jldoctest
julia> using QEDbase

julia> Outgoing()
outgoing
```

!!! note "ParticleDirection Interface"
    Besides being a subtype of [`ParticleDirection`](@ref), `Outgoing` has

    ```julia
    is_incoming(::Outgoing) = false
    is_outgoing(::Outgoing) = true
    ```
"""
struct Outgoing <: ParticleDirection end
is_incoming(::Outgoing) = false
is_outgoing(::Outgoing) = true
Base.show(io::IO, ::Outgoing) = print(io, "outgoing")

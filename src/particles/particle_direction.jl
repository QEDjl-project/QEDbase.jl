"""
Abstract base type for the directions of particles in the context of processes, i.e. either they are *incoming* or *outgoing*. Subtypes of this are mostly used for dispatch.
"""
abstract type ParticleDirection end

"""
    Incoming <: ParticleDirection

Concrete implementation of a [`ParticleDirection`](@ref) to indicate that a particle is *incoming* in the context of a given process. Mostly used for dispatch.

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

"""
    Outgoing <: ParticleDirection

Concrete implementation of a [`ParticleDirection`](@ref) to indicate that a particle is *outgoing* in the context of a given process. Mostly used for dispatch.

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

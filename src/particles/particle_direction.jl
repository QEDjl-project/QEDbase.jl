"""
Abstract base type for the directions of particles in the context of processes, i.e. either they are *incoming* or *outgoing*. Subtypes of this are mostly used for dispatch.
"""
abstract type ParticleDirection end
Base.broadcastable(dir::ParticleDirection) = Ref(dir)

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
Base.show(io::IO, ::MIME"text/plain", ::Incoming) = print(io, "incoming")

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
Base.show(io::IO, ::MIME"text/plain", ::Outgoing) = print(io, "outgoing")

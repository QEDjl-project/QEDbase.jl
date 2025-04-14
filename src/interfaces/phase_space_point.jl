"""
    AbstractPhaseSpacePoint{PROC, MODEL, PSL, IN_PARTICLES, OUT_PARTICLES}

Representation of a point in the phase space of a process. It has several template arguments:
- `PROC <: `[`AbstractProcessDefinition`](@ref)
- `MODEL <: `[`AbstractModelDefinition`](@ref)
- `PSL <: `[`AbstractPhaseSpaceLayout`](@ref)
- `IN_PARTICLES <: `Tuple{Vararg{AbstractParticleStateful}}`: The tuple type of all the incoming [`AbstractParticleStateful`](@ref)s.
- `OUT_PARTICLES <: `Tuple{Vararg{AbstractParticleStateful}}`: The tuple type of all the outgoing [`AbstractParticleStateful`](@ref)s.

The following interface functions must be provided:
- `Base.getindex(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)`: Return the nth [`AbstractParticleStateful`](@ref) of the given direction. Throw `BoundsError` for invalid indices.
- `particles(psp::AbstractPhaseSpacePoint, dir::ParticleDirection)`: Return the particle tuple (type `IN_PARTICLES` or `OUT_PARTICLES` depending on `dir`)
- [`process`](@ref): Return the process.
- [`model`](@ref): Return the model.
- [`phase_space_layout`](@ref): Return the phase space layout.

From this, the following functions are automatically derived:
- `momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)`: Return the momentum of the nth [`AbstractParticleStateful`](@ref) of the given direction.
- `momenta(psp::PhaseSpacePoint, ::ParticleDirection)`: Return a `Tuple` of all the momenta of the given direction.

Furthermore, an implementation of an [`AbstractPhaseSpacePoint`](@ref) has to verify on construction that it is valid, i.e., the following conditions are fulfilled:
- `IN_PARTICLES` must match `incoming_particles(::PROC)` in length, order, and type **or** be an empty `Tuple`.
- `OUT_PARTICLES` must match the `outgoing_particles(::PROC)` in length, order, and type, **or** be an empty `Tuple`.
- `IN_PARTICLES` and `OUT_PARTICLES` may not both be empty.

If `IN_PARTICLES` is non-empty, `AbstractPhaseSpacePoint <: AbstractInPhaseSpacePoint` is true. Likewise, if `OUT_PARTICLES` is non-empty, `AbstractPhaseSpacePoint <: AbstractOutPhaseSpacePoint` is true. Consequently, if both `IN_PARTICLES` and `OUT_PARTICLES` are non-empty, both `<:` statements are true.
"""
abstract type AbstractPhaseSpacePoint{
    PROC<:AbstractProcessDefinition,
    MODEL<:AbstractModelDefinition,
    PSL<:AbstractPhaseSpaceLayout,
    IN_PARTICLES<:Tuple{Vararg{AbstractParticleStateful}},
    OUT_PARTICLES<:Tuple{Vararg{AbstractParticleStateful}},
} end

"""
    process(psp::AbstractPhaseSpacePoint)

Return the phase space point's set process.

See also: [`AbstractProcessDefinition`](@ref)
"""
function process end

"""
    model(psp::AbstractPhaseSpacePoint)

Return the phase space point's set model.

See also: [`AbstractModelDefinition`](@ref)
"""
function model end

"""
    phase_space_layout(psp::AbstractPhaseSpacePoint)

Return the phase space point's set phase space layout.

See also: [`AbstractPhaseSpaceLayout`](@ref)
"""
function phase_space_layout end

"""
    AbstractInPhaseSpacePoint

A partial type specialization on [`AbstractPhaseSpacePoint`](@ref) which can be used for dispatch in functions requiring only the in channel of the phase space to exist, for example implementations of [`_incident_flux`](@ref). No restrictions are imposed on the out-channel, which may or may not exist.

See also: [`AbstractOutPhaseSpacePoint`](@ref)
"""
AbstractInPhaseSpacePoint{P,M,D,IN,OUT} = AbstractPhaseSpacePoint{
    P,M,D,IN,OUT
} where {PS<:AbstractParticleStateful,IN<:Tuple{PS,Vararg},OUT<:Tuple{Vararg}}

"""
    AbstractOutPhaseSpacePoint

A partial type specialization on [`AbstractPhaseSpacePoint`](@ref) which can be used for dispatch in functions requiring only the out channel of the phase space to exist. No restrictions are imposed on the in-channel, which may or may not exist.

See also: [`AbstractInPhaseSpacePoint`](@ref)
"""
AbstractOutPhaseSpacePoint{P,M,D,IN,OUT} = AbstractPhaseSpacePoint{
    P,M,D,IN,OUT
} where {PS<:AbstractParticleStateful,IN<:Tuple{Vararg},OUT<:Tuple{PS,Vararg}}

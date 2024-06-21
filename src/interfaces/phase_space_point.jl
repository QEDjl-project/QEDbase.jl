"""
    AbstractPhaseSpacePoint{PROC, MODEL, PSDEF, IN_PARTICLES, OUT_PARTICLES, ELEMENT}

Representation of a point in the phase space of a process. It has several template arguments:
- `PROC <: `[`AbstractProcessDefinition`](@ref)
- `MODEL <: `[`AbstractModelDefinition`](@ref)
- `PSDEF <: `[`AbstractPhasespaceDefinition`](@ref)
- `IN_PARTICLES <: `Tuple{Vararg{AbstractParticleStateful}}`: The tuple type of all the incoming [`AbstractParticleStateful`](@ref)s.
- `OUT_PARTICLES <: `Tuple{Vararg{AbstractParticleStateful}}`: The tuple type of all the outgoing [`AbstractParticleStateful`](@ref)s.
- `ELEMENT <: `[`AbstractFourMomentum`](@ref): The type of the [`AbstractParticleStateful`](@ref)s and also the return type of the [`momentum`](@ref) interface function.

The following interface functions must be provided:
- `Base.getindex(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)`: Return the nth [`AbstractParticleStateful`](@ref) of the given direction. Throw `BoundsError` for invalid indices.
- [`process`](@ref): Return the process.
- [`model`](@ref): Return the model.
- [`phase_space_definition`](@ref): Return the phase space definition.

From this, the following functions are automatically derived:
- `momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)::ELEMENT`: Return the momentum of the nth [`AbstractParticleStateful`](@ref) of the given direction.
- `momenta(psp::PhaseSpacePoint, ::ParticleDirection)::ELEMENT`: Return a `Tuple` of all the momenta of the given direction.

Furthermore, an implementation of an [`AbstractPhaseSpacePoint`](@ref) has to verify on construction that it is valid, i.e., the following conditions are fulfilled:
- `IN_PARTICLES` must match `incoming_particles(::PROC)` in length, order, and type **or** be an empty `Tuple`.
- `OUT_PARTICLES` must match the `outgoing_particles(::PROC)` in length, order, and type, **or** be an empty `Tuple`.
- `IN_PARTICLES` and `OUT_PARTICLES` may not both be empty.

If `IN_PARTICLES` is non-empty, `AbstractPhaseSpacePoint <: AbstractInPhaseSpacePoint` is true. Likewise, if `OUT_PARTICLES` is non-empty, `AbstractPhaseSpacePoint <: AbstractOutPhaseSpacePoint` is true. Consequently, if both `IN_PARTICLES` and `OUT_PARTICLES` are non-empty, both `<:` statements are true.
"""
abstract type AbstractPhaseSpacePoint{
    PROC<:AbstractProcessDefinition,
    MODEL<:AbstractModelDefinition,
    PSDEF<:AbstractPhasespaceDefinition,
    IN_PARTICLES<:Tuple{Vararg{AbstractParticleStateful}},
    OUT_PARTICLES<:Tuple{Vararg{AbstractParticleStateful}},
    ELEMENT<:AbstractFourMomentum,
} end

"""
    process(psp::AbstractPhaseSpacePoint)

Return the phase space point's set process.
"""
function process end

"""
    model(psp::AbstractPhaseSpacePoint)

Return the phase space point's set model.
"""
function model end

"""
    phase_space_definition(psp::AbstractPhaseSpacePoint)

Return the phase space point's set phase space definition.
"""
function phase_space_definition end

"""
    momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)

Returns the momentum of the `n`th particle in the given [`AbstractPhaseSpacePoint`](@ref) which has direction `dir`. If `n` is outside the valid range for this phase space point, a `BoundsError` is thrown.
"""
function momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)
    return psp[dir, n].mom
end

"""
    momenta(psp::AbstractPhaseSpacePoint, ::ParticleDirection)

Return a `Tuple` of all the particles' momenta for the given `ParticleDirection`.
"""
momenta(psp::AbstractPhaseSpacePoint, ::QEDbase.Incoming) = momentum.(psp.in_particles)
momenta(psp::AbstractPhaseSpacePoint, ::QEDbase.Outgoing) = momentum.(psp.out_particles)

"""
    AbstractInPhaseSpacePoint

A partial type specialization on [`AbstractPhaseSpacePoint`](@ref) which can be used for dispatch in functions requiring only the in channel of the phase space to exist, for example implementations of [`_incident_flux`](@ref). No restrictions are imposed on the out-channel, which may or may not exist.

See also: [`AbstractOutPhaseSpacePoint`](@ref)
"""
AbstractInPhaseSpacePoint{P,M,D,IN,OUT,E} = AbstractPhaseSpacePoint{
    P,M,D,IN,OUT,E
} where {PS<:AbstractParticleStateful,IN<:Tuple{PS,Vararg},OUT<:Tuple{Vararg}}

"""
    AbstractOutPhaseSpacePoint

A partial type specialization on [`AbstractPhaseSpacePoint`](@ref) which can be used for dispatch in functions requiring only the out channel of the phase space to exist. No restrictions are imposed on the in-channel, which may or may not exist.

See also: [`AbstractInPhaseSpacePoint`](@ref)
"""
AbstractOutPhaseSpacePoint{P,M,D,IN,OUT,E} = AbstractPhaseSpacePoint{
    P,M,D,IN,OUT,E
} where {PS<:AbstractParticleStateful,IN<:Tuple{Vararg},OUT<:Tuple{PS,Vararg}}

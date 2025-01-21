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
    momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)

Returns the momentum of the `n`th particle in the given [`AbstractPhaseSpacePoint`](@ref) which has direction `dir`. If `n` is outside the valid range for this phase space point, a `BoundsError` is thrown.
"""
function momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, n::Int)
    return momentum(psp[dir, n])
end

function _momentum_helper(particles::Tuple{}, species::SPECIES, n::Val{N}) where {SPECIES,N}
    throw(
        BoundsError(
            "momentum(): requested $species momentum is not in this phase space point"
        ),
    )
end

function _momentum_helper(
    particles::Tuple{AbstractParticleStateful{DIR,SPECIES,EL},Vararg},
    species::SPECIES,
    n::Val{1},
) where {DIR,SPECIES,EL}
    return momentum(particles[1])
end

function _momentum_helper(
    particles::Tuple{AbstractParticleStateful{DIR,SPECIES1,EL},Vararg},
    species::SPECIES2,
    n::Val{N},
) where {DIR,SPECIES1,SPECIES2,EL,N}
    return _momentum_helper(particles[2:end], species, n)
end

function _momentum_helper(
    particles::Tuple{AbstractParticleStateful{DIR,SPECIES,EL},Vararg},
    species::SPECIES,
    n::Val{N},
) where {DIR,SPECIES,EL,N}
    return _momentum_helper(particles[2:end], species, Val(N - 1))
end

"""
    momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, species::AbstractParticleType, n::Val{N})

Returns the momentum of the `n`th particle in the given [`AbstractPhaseSpacePoint`](@ref) which has direction `dir` and species `species`. If `n` is outside the valid range for this phase space point, a `BoundsError` is thrown.

!!! note
    This function accepts n as a `Val{N}` type, i.e., a compile-time constant value (for example a literal `1` or `2`). This allows this function to add zero overhead, but **only** if `N` is actually known at compile time.
    If it is not, use the overload of this function that uses `n::Int` instead. That function is faster than calling this one with `Val(n)`.
"""
function momentum(
    psp::AbstractPhaseSpacePoint,
    dir::ParticleDirection,
    species::AbstractParticleType,
    n::Val{N},
) where {N}
    return _momentum_helper(particles(psp, dir), species, n)
end

"""
    momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, species::AbstractParticleType)

Returns the momentum of the particle in the given [`AbstractPhaseSpacePoint`](@ref) with `dir` and `species`, *if* there is only one such particle. If there are multiple or none, an [`InvalidInputError`](@ref) is thrown.
"""
function momentum(
    psp::AbstractPhaseSpacePoint, dir::ParticleDirection, species::AbstractParticleType
)
    if (number_particles(process(psp), dir, species) != 1)
        throw(
            InvalidInputError(
                "this overload only works when exactly one $dir $species exists in the phase space point, but $(number_particles(process(psp), dir, species)) exist in this one; to specify an index, use momentum(psp, dir, species, n)",
            ),
        )
    end

    return momentum(psp, dir, species, Val(1))
end

"""
    momentum(psp::AbstractPhaseSpacePoint, dir::ParticleDirection, species::AbstractParticleType, n::Int)

Returns the momentum of the `n`th particle in the given [`AbstractPhaseSpacePoint`](@ref) which has direction `dir` and species `species`. If `n` is outside the valid range for this phase space point, a `BoundsError` is thrown.

!!! note
    This function accepts n as an `Int` value. If `n` is a compile-time constant (for example, a literal `1` or `2`), you can use `Val(n)` instead to call a zero overhead version of this function.
"""
function momentum(
    psp::AbstractPhaseSpacePoint,
    dir::ParticleDirection,
    species::AbstractParticleType,
    n::Int,
)
    i = 0
    c = n
    for p in particles(psp, dir)
        i += 1
        if particle_species(p) == species
            c -= 1
        end
        if c == 0
            break
        end
    end

    if c != 0 || n <= 0
        throw(BoundsError("could not get $n-th momentum of $dir $species, does not exist"))
    end

    return momenta(psp, dir)[i]
end

"""
    momenta(psp::AbstractPhaseSpacePoint, ::ParticleDirection)

Return a `Tuple` of all the particles' momenta for the given `ParticleDirection`.
"""
function momenta(psp::AbstractPhaseSpacePoint, dir::ParticleDirection)
    return ntuple(i -> momentum(psp[dir, i]), number_particles(process(psp), dir))
end

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

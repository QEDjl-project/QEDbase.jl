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
    momentum_type(psp::Type{AbstractPhaseSpacePoint})
    momentum_type(psp::AbstractPhaseSpacePoint)

Return the type of the stored momenta in the phase space point.

See also: [`momentum_eltype`](@ref)
"""
@inline function momentum_type(::Type{<:AbstractPhaseSpacePoint{P,M,L,PS}}) where {P,M,L,PS}
    return momentum_type(PS.parameters[1])
end
@inline momentum_type(psp::AbstractPhaseSpacePoint) = momentum_type(typeof(psp))

"""
    momentum_eltype(psp::Type{AbstractPhaseSpacePoint})
    momentum_eltype(psp::AbstractPhaseSpacePoint)

Short for `eltype(momentum_type(psp))`, i.e., returning the momentum's element type.

See also: [`momentum_type`](@ref)
"""
@inline momentum_eltype(psp::Type{<:AbstractPhaseSpacePoint}) = eltype(momentum_type(psp))
@inline momentum_eltype(psp::AbstractPhaseSpacePoint) = momentum_eltype(typeof(psp))

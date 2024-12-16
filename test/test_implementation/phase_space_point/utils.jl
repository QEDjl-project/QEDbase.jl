
# utility copied from QEDcore

# recursion termination: base case
@inline _assemble_tuple_type(::Tuple{}, ::ParticleDirection, ::Type) = ()

# function assembling the correct type information for the tuple of ParticleStatefuls in a phasespace point constructed from momenta
@inline function _assemble_tuple_type(
    particle_types::Tuple{SPECIES_T,Vararg{AbstractParticleType}}, dir::DIR_T, ELTYPE::Type
) where {SPECIES_T<:AbstractParticleType,DIR_T<:ParticleDirection}
    return (
        TestParticleStateful{DIR_T,SPECIES_T,ELTYPE},
        _assemble_tuple_type(particle_types[2:end], dir, ELTYPE)...,
    )
end

@inline _build_ps_helper(dir::ParticleDirection, particles::Tuple{}, moms::Tuple{}) = ()
@inline function _build_ps_helper(
    dir::ParticleDirection,
    particles::Tuple{P,Vararg},
    moms::Tuple{AbstractFourMomentum,Vararg},
) where {P}
    return (
        TestParticleStateful(dir, particles[1], moms[1]),
        _build_ps_helper(dir, particles[2:end], moms[2:end])...,
    )
end

# convenience function building a type stable tuple of ParticleStatefuls from the given process, momenta, and direction
@inline function _build_particle_statefuls(
    proc::AbstractProcessDefinition, moms::NTuple{N,ELEMENT}, dir::ParticleDirection
) where {N,ELEMENT<:AbstractFourMomentum}
    res::Tuple{_assemble_tuple_type(particles(proc, dir), dir, ELEMENT)...} = _build_ps_helper(
        dir, particles(proc, dir), moms
    )

    return res
end

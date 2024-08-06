"""
    number_incoming_particles(proc_def::AbstractProcessDefinition)

Return the number of incoming particles of a given process. 
"""
@inline function number_incoming_particles(proc_def::AbstractProcessDefinition)
    return length(incoming_particles(proc_def))
end

"""
    number_outgoing_particles(proc_def::AbstractProcessDefinition)

Return the number of outgoing particles of a given process. 
"""
@inline function number_outgoing_particles(proc_def::AbstractProcessDefinition)
    return length(outgoing_particles(proc_def))
end

"""
    particles(proc_def::AbstractProcessDefinition, ::ParticleDirection)

Convenience function dispatching to [`incoming_particles`](@ref) or [`outgoing_particles`](@ref) depending on the given direction.
"""
@inline particles(proc_def::AbstractProcessDefinition, ::Incoming) =
    incoming_particles(proc_def)
@inline particles(proc_def::AbstractProcessDefinition, ::Outgoing) =
    outgoing_particles(proc_def)

"""
    number_particles(proc_def::AbstractProcessDefinition, dir::ParticleDirection)

Convenience function dispatching to [`number_incoming_particles`](@ref) or [`number_outgoing_particles`](@ref) depending on the given direction, returning the number of incoming or outgoing particles, respectively.
"""
@inline number_particles(proc_def::AbstractProcessDefinition, ::Incoming) =
    number_incoming_particles(proc_def)
@inline number_particles(proc_def::AbstractProcessDefinition, ::Outgoing) =
    number_outgoing_particles(proc_def)

"""
    number_particles(proc_def::AbstractProcessDefinition, dir::ParticleDirection, species::AbstractParticleType)

Return the number of particles of the given direction and species in the given process definition.
"""
@inline function number_particles(
    proc_def::AbstractProcessDefinition, dir::DIR, species::PT
) where {DIR<:ParticleDirection,PT<:AbstractParticleType}
    return count(x -> x isa PT, particles(proc_def, dir))
end

"""
    number_particles(proc_def::AbstractProcessDefinition, particle::AbstractParticleStateful)

Return the number of particles of the given particle's direction and species in the given process definition.
"""
@inline function number_particles(
    proc_def::AbstractProcessDefinition, ps::AbstractParticleStateful
)
    return number_particles(proc_def, particle_direction(ps), particle_species(ps))
end

# default implementation
function incoming_spin_pols(proc_def::AbstractProcessDefinition)
    return ntuple(
        x -> is_fermion(incoming_particles(proc_def)[x]) ? AllSpin() : AllPolarization(),
        number_incoming_particles(proc_def),
    )
end

# default implementation
function outgoing_spin_pols(proc_def::AbstractProcessDefinition)
    return ntuple(
        x -> is_fermion(outgoing_particles(proc_def)[x]) ? AllSpin() : AllPolarization(),
        number_outgoing_particles(proc_def),
    )
end

"""
    spin_pols(proc_def::AbstractProcessDefinition, dir::ParticleDirection)

Return the tuple of spins and polarizations for the process in the given direction. Dispatches to [`incoming_spin_pols`](@ref) or [`outgoing_spin_pols`](@ref).
"""
spin_pols(proc_def::AbstractProcessDefinition, dir::Incoming) = incoming_spin_pols(proc_def)
spin_pols(proc_def::AbstractProcessDefinition, dir::Outgoing) = outgoing_spin_pols(proc_def)

"""
    _generate_momenta(
        proc::AbstractProcessDefinition,
        model::AbstractModelDefinition,
        phase_space_def::AbstractPhasespaceDefinition,
        in_phase_space::NTuple{N,T},
        out_phase_space::NTuple{M,T},
    ) where {N,M,T<:Real}

Return four-momenta for incoming and outgoing particles for given coordinate based phase-space points. 
"""
function _generate_momenta(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    phase_space_def::AbstractPhasespaceDefinition,
    in_phase_space::NTuple{N,T},
    out_phase_space::NTuple{M,T},
) where {N,M,T<:Real}
    in_momenta = _generate_incoming_momenta(proc, model, phase_space_def, in_phase_space)
    out_momenta = _generate_outgoing_momenta(
        proc, model, phase_space_def, in_phase_space, out_phase_space
    )

    return in_momenta, out_momenta
end

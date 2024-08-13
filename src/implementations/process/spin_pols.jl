
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
    multiplicity(proc::AbstractProcessDefinition)

Return the number of spin and polarization combinations represented by `proc` total. This depends on the specific [`AbstractSpinOrPolarization`](@ref)s returned by [`spin_pols`](@ref) for `proc`.
For example, a default Compton process with four indefinite spins/polarizations has a multiplicity of 2^4 = 16. A Compton process with many incoming photons that have synced polarizations
will still have a multiplicity of 16.

See also: [`SyncedPolarization`](@ref), [`SyncedSpin`](@ref)
"""
function multiplicity(proc::AbstractProcessDefinition)
end

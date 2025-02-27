
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

@inline _multiplicity(::AbstractDefinitePolarization) = 1
@inline _multiplicity(::AbstractDefiniteSpin) = 1
@inline _multiplicity(::AllSpin) = 2
@inline _multiplicity(::AllPol) = 2

@inline _multiplicity(::SyncedPolarization{N}, seen_spin_pols::Tuple{}) where {N} = 2
@inline _multiplicity(::SyncedSpin{N}, seen_spin_pols::Tuple{}) where {N} = 2

@inline function _multiplicity(
    sp::SyncedPolarization{N}, seen_pols::Tuple{Int,Vararg{Int}}
) where {N}
    if seen_pols[1] == N
        return 1
    else
        return _multiplicity(sp, seen_pols[2:end])
    end
end

@inline function _multiplicity(
    ss::SyncedSpin{N}, seen_spins::Tuple{Int,Vararg{Int}}
) where {N}
    if seen_spins[1] == N
        return 1
    else
        return _multiplicity(ss, seen_spins[2:end])
    end
end

# multiplicity of the empty spin_pol set is 1
@inline _multiplicity(::Tuple{}, _, _) = 1

# recursion for abstract spins or pols that are not synced
@inline function _multiplicity(
    spin_pols::Tuple{AbstractSpin,Vararg{AbstractSpinOrPolarization}},
    seen_spins::NTuple{S,Int},
    seen_pols::NTuple{P,Int},
) where {S,P}
    return _multiplicity(spin_pols[1]) *
           _multiplicity(spin_pols[2:end], seen_spins, seen_pols)
end
@inline function _multiplicity(
    spin_pols::Tuple{AbstractPolarization,Vararg{AbstractSpinOrPolarization}},
    seen_spins::NTuple{S,Int},
    seen_pols::NTuple{P,Int},
) where {S,P}
    return _multiplicity(spin_pols[1]) *
           _multiplicity(spin_pols[2:end], seen_spins, seen_pols)
end

# recursion for synced spins or pols
@inline function _multiplicity(
    spin_pols::Tuple{SyncedPolarization{N},Vararg{AbstractSpinOrPolarization}},
    seen_spins::NTuple{S,Int},
    seen_pols::NTuple{P,Int},
) where {N,S,P}
    return _multiplicity(spin_pols[1], seen_pols) *
           _multiplicity(spin_pols[2:end], seen_spins, (seen_pols..., N))
end
@inline function _multiplicity(
    spin_pols::Tuple{SyncedSpin{N},Vararg{AbstractSpinOrPolarization}},
    seen_spins::NTuple{S,Int},
    seen_pols::NTuple{P,Int},
) where {N,S,P}
    return _multiplicity(spin_pols[1], seen_spins) *
           _multiplicity(spin_pols[2:end], (seen_spins..., N), seen_pols)
end

"""
    multiplicity(proc::AbstractProcessDefinition)

Return the number of spin and polarization combinations represented by `proc` total. This depends on the specific [`AbstractSpinOrPolarization`](@ref)s returned by [`spin_pols`](@ref) for `proc`.
For example, a default Compton process with four indefinite spins/polarizations has a multiplicity of 2^4 = 16. A Compton process with many incoming photons that have synced polarizations
will still have a multiplicity of 16.

!!! note "Performance"
    As long as [`incoming_spin_pols`](@ref) and [`outgoing_spin_pols`](@ref) can be evaluated at compile time, this function is completely compiled away.

!!! note "Incoming and Outgoing Spins/Polarizations"
    Note that the total multiplicity is not necessarily the incoming and outgoing multiplicities multiplied. This is the case when incoming and outgoing particles are synced with one another.

See also: [`SyncedPolarization`](@ref), [`SyncedSpin`](@ref), [`incoming_multiplicity`](@ref), [`outgoing_multiplicity`](@ref)
"""
function multiplicity(proc::AbstractProcessDefinition)
    return _multiplicity(
        (incoming_spin_pols(proc)..., outgoing_spin_pols(proc)...),
        NTuple{0,Int}(),
        NTuple{0,Int}(),
    )
end

"""
    incoming_multiplicity(proc::AbstractProcessDefinition)

Return the number of spin and polarization combinations represented by `proc`s incoming particles. This function only considers the incoming particles' spins and polarizations, returned by
[`incoming_spin_pols`](@ref) for `proc`.

!!! note "Incoming and Outgoing Spins/Polarizations"
    Note that the total multiplicity is not necessarily the incoming and outgoing multiplicities multiplied. For the total process multiplicity, see [`multiplicity`](@ref).

See also: [`SyncedPolarization`](@ref), [`SyncedSpin`](@ref), [`multiplicity`](@ref), [`outgoing_multiplicity`](@ref)
"""
function incoming_multiplicity(proc::AbstractProcessDefinition)
    return _multiplicity(incoming_spin_pols(proc), NTuple{0,Int}(), NTuple{0,Int}())
end

"""
    outgoing_multiplicity(proc::AbstractProcessDefinition)

Return the number of spin and polarization combinations represented by `proc`s outgoing particles. This function only considers the outgoing particles' spins and polarizations, returned by
[`outgoing_spin_pols`](@ref) for `proc`.

!!! note "Incoming and Outgoing Spins/Polarizations"
    Note that the total multiplicity is not necessarily the incoming and outgoing multiplicities multiplied. For the total process multiplicity, see [`multiplicity`](@ref).

See also: [`SyncedPolarization`](@ref), [`SyncedSpin`](@ref), [`multiplicity`](@ref), [`incoming_multiplicity`](@ref)
"""
function outgoing_multiplicity(proc::AbstractProcessDefinition)
    return _multiplicity(outgoing_spin_pols(proc), NTuple{0,Int}(), NTuple{0,Int}())
end

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

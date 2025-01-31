
function QEDbase._incident_flux(
    in_psp::MockPhaseSpacePoint{<:MockProcess,<:MockModel,<:MockPhasespaceDef}
)
    return _groundtruth_incident_flux(momenta(in_psp, Incoming()))
end

function QEDbase._averaging_norm(proc::MockProcess)
    return _groundtruth_averaging_norm(proc)
end

function QEDbase._matrix_element(
    psp::MockPhaseSpacePoint{<:MockProcess,<:MockModel,<:MockPhasespaceDef}
)
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_matrix_element(in_ps, out_ps)
end

function QEDbase._is_in_phasespace(
    psp::MockPhaseSpacePoint{<:MockProcess,<:MockModel,<:MockPhasespaceDef}
)
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_is_in_phasespace(in_ps, out_ps)
end

function QEDbase._phase_space_factor(
    psp::MockPhaseSpacePoint{<:MockProcess,<:MockModel,<:MockPhasespaceDef}
)
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_phase_space_factor(in_ps, out_ps)
end

function QEDbase._total_probability(
    in_psp::MockPhaseSpacePoint{<:MockProcess,<:MockModel,<:MockPhasespaceDef}
)
    return _groundtruth_total_probability(momenta(in_psp, Incoming()))
end


# TODO: implement using TestPSP, not PhaseSpacePoint
function QEDbase._incident_flux(in_psp::InPhaseSpacePoint{<:TestProcess,<:TestModel})
    return _groundtruth_incident_flux(momenta(in_psp, Incoming()))
end

function QEDbase._averaging_norm(proc::TestProcess)
    return _groundtruth_averaging_norm(proc)
end

function QEDbase._matrix_element(psp::PhaseSpacePoint{<:TestProcess,<:TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_matrix_element(in_ps, out_ps)
end

function QEDbase._is_in_phasespace(psp::PhaseSpacePoint{<:TestProcess,<:TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_is_in_phasespace(in_ps, out_ps)
end

function QEDbase._phase_space_factor(psp::PhaseSpacePoint{<:TestProcess,<:TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_phase_space_factor(in_ps, out_ps)
end

function QEDbase._total_probability(
    in_psp::InPhaseSpacePoint{<:TestProcess,<:TestModel,<:TestPhasespaceDef}
)
    return _groundtruth_total_probability(momenta(in_psp, Incoming()))
end

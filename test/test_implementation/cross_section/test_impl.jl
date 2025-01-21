
function QEDbase._incident_flux(in_psp::TestPhaseSpacePoint{<:TestProcess,<:TestModel})
    return _groundtruth_incident_flux(momenta(in_psp, Incoming()))
end

function QEDbase._averaging_norm(proc::TestProcess)
    return _groundtruth_averaging_norm(proc)
end

function QEDbase._matrix_element(psp::TestPhaseSpacePoint{<:TestProcess,<:TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_matrix_element(in_ps, out_ps)
end

function QEDbase._is_in_phasespace(psp::TestPhaseSpacePoint{<:TestProcess,<:TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_is_in_phasespace(in_ps, out_ps)
end

function QEDbase._phase_space_factor(
    psp::TestPhaseSpacePoint{<:TestProcess,<:TestModel,<:TestOutPhaseSpaceLayout}
)
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_phase_space_factor(in_ps, out_ps)
end

function QEDbase._total_probability(
    in_psp::TestPhaseSpacePoint{<:TestProcess,<:TestModel,<:TestInPhaseSpaceLayout}
)
    return _groundtruth_total_probability(momenta(in_psp, Incoming()))
end

function QEDbase._total_probability(
    in_psp::TestPhaseSpacePoint{<:TestProcess,<:TestModel,<:TestOutPhaseSpaceLayout}
)
    return _groundtruth_total_probability(momenta(in_psp, Incoming()))
end

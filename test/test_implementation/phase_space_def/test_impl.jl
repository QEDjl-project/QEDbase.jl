
# dummy phase space definition + failing phase space definition
struct TestPhasespaceDef <: AbstractPhasespaceDefinition end
struct TestPhasespaceDef_FAIL <: AbstractPhasespaceDefinition end

function QEDbase._generate_incoming_momenta(
    proc::TestProcess,
    model::TestModel,
    phase_space_def::TestPhasespaceDef,
    in_phase_space::NTuple{N,T},
) where {N,T<:Real}
    return _groundtruth_generate_momenta(in_phase_space)
end

function QEDbase._generate_outgoing_momenta(
    proc::TestProcess,
    model::TestModel,
    phase_space_def::TestPhasespaceDef,
    in_phase_space::NTuple{N,T},
    out_phase_space::NTuple{M,T},
) where {N,M,T<:Real}
    return _groundtruth_generate_momenta(out_phase_space)
end

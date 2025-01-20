
# dummy phase space definition + failing phase space definition
struct TestPhasespaceDef{MOM_TYPE<:AbstractTestMomentum} <: AbstractPhasespaceDefinition end
function Base.eltype(
    ::Type{PSD}
) where {MOM_TYPE<:AbstractTestMomentum,PSD<:TestPhasespaceDef{MOM_TYPE}}
    return MOM_TYPE
end
function Base.eltype(
    ::PSD
) where {MOM_TYPE<:AbstractTestMomentum,PSD<:TestPhasespaceDef{MOM_TYPE}}
    return MOM_TYPE
end

struct TestPhasespaceDef_FAIL <: AbstractPhasespaceDefinition end

function QEDbase._generate_incoming_momenta(
    proc::TestProcess,
    model::TestModel,
    phase_space_def::TestPhasespaceDef,
    in_phase_space::NTuple{N,T},
) where {N,T<:Real}
    return _groundtruth_generate_momenta(in_phase_space, eltype(phase_space_def))
end

function QEDbase._generate_outgoing_momenta(
    proc::TestProcess,
    model::TestModel,
    phase_space_def::TestPhasespaceDef,
    in_phase_space::NTuple{N,T},
    out_phase_space::NTuple{M,T},
) where {N,M,T<:Real}
    return _groundtruth_generate_momenta(out_phase_space, eltype(phase_space_def))
end

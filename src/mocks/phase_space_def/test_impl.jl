
# dummy phase space definition + failing phase space definition
struct MockPhasespaceDef{MOM_TYPE<:AbstractMockMomentum} <: AbstractPhasespaceDefinition end
function Base.eltype(
    ::Type{PSD}
) where {MOM_TYPE<:AbstractMockMomentum,PSD<:MockPhasespaceDef{MOM_TYPE}}
    return MOM_TYPE
end
function Base.eltype(
    ::PSD
) where {MOM_TYPE<:AbstractMockMomentum,PSD<:MockPhasespaceDef{MOM_TYPE}}
    return MOM_TYPE
end

struct MockPhasespaceDef_FAIL <: AbstractPhasespaceDefinition end

function QEDbase._generate_incoming_momenta(
    proc::MockProcess,
    model::MockModel,
    phase_space_def::MockPhasespaceDef,
    in_phase_space::NTuple{N,T},
) where {N,T<:Real}
    return _groundtruth_generate_momenta(in_phase_space, eltype(phase_space_def))
end

function QEDbase._generate_outgoing_momenta(
    proc::MockProcess,
    model::MockModel,
    phase_space_def::MockPhasespaceDef,
    in_phase_space::NTuple{N,T},
    out_phase_space::NTuple{M,T},
) where {N,M,T<:Real}
    return _groundtruth_generate_momenta(out_phase_space, eltype(phase_space_def))
end

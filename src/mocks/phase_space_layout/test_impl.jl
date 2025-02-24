### Trivial phase-space layouts

# maps all components onto four momenta
struct MockInPhaseSpaceLayout{MOM_TYPE<:AbstractMockMomentum} <:
       QEDbase.AbstractInPhaseSpaceLayout end
function Base.eltype(
    ::Type{PSL}
) where {MOM_TYPE<:AbstractMockMomentum,PSL<:MockInPhaseSpaceLayout{MOM_TYPE}}
    return MOM_TYPE
end
function Base.eltype(
    ::PSL
) where {MOM_TYPE<:AbstractMockMomentum,PSL<:MockInPhaseSpaceLayout{MOM_TYPE}}
    return MOM_TYPE
end

@inline QEDbase.phase_space_dimension(
    proc::AbstractProcessDefinition, ::AbstractModelDefinition, ::MockInPhaseSpaceLayout
) = 4 * number_incoming_particles(proc)

@inline function QEDbase._build_momenta(
    ::MockProcess, ::MockModel, in_psl::MockInPhaseSpaceLayout, in_coords
)
    return _groundtruth_in_moms(in_coords, eltype(in_psl))
end

# maps components of N-1 particles onto four-momenta and uses energy-momentum conservation
struct MockOutPhaseSpaceLayout{INPSL,MOM_TYPE} <: QEDbase.AbstractOutPhaseSpaceLayout{INPSL}
    in_psl::INPSL

    function MockOutPhaseSpaceLayout(
        in_psl::INPSL
    ) where {MOM_TYPE<:AbstractMockMomentum,INPSL<:MockInPhaseSpaceLayout{MOM_TYPE}}
        return new{INPSL,MOM_TYPE}(in_psl)
    end
end

function MockOutPhaseSpaceLayout(
    mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractMockMomentum}
    return MockOutPhaseSpaceLayout(MockInPhaseSpaceLayout{MOM_TYPE}())
end

function Base.eltype(
    ::Type{PSL}
) where {MOM_TYPE<:AbstractMockMomentum,INPSL,PSL<:MockOutPhaseSpaceLayout{INPSL,MOM_TYPE}}
    return MOM_TYPE
end
function Base.eltype(
    ::PSL
) where {MOM_TYPE<:AbstractMockMomentum,INPSL,PSL<:MockOutPhaseSpaceLayout{INPSL,MOM_TYPE}}
    return MOM_TYPE
end

@inline QEDbase.in_phase_space_layout(psl::MockOutPhaseSpaceLayout) = psl.in_psl

@inline QEDbase.phase_space_dimension(
    proc::AbstractProcessDefinition, ::AbstractModelDefinition, ::MockOutPhaseSpaceLayout
) = 4 * number_outgoing_particles(proc) - 4

@inline function QEDbase._build_momenta(
    proc::MockProcess,
    model::MockModel,
    in_moms::NTuple{NIN,AbstractFourMomentum},
    out_psl::MockOutPhaseSpaceLayout,
    out_coords,
) where {NIN}
    return _groundtruth_out_moms(in_moms, out_coords, eltype(out_psl))
end

function Base.show(io::IO, psl::QEDbase.Mocks.MockOutPhaseSpaceLayout)
    return print(io, "mock out phase space layout")
end

struct MockInPhaseSpaceLayout_FAIL <: QEDbase.AbstractInPhaseSpaceLayout end
struct MockOutPhaseSpaceLayout_FAIL <:
       QEDbase.AbstractOutPhaseSpaceLayout{MockInPhaseSpaceLayout}
    in_psl::MockInPhaseSpaceLayout
end
function MockOutPhaseSpaceLayout_FAIL(
    mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractMockMomentum}
    return MockOutPhaseSpaceLayout_FAIL(MockInPhaseSpaceLayout{MOM_TYPE}())
end

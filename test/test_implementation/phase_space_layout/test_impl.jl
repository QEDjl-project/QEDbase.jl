### Trivial phase-space layouts

# maps all components onto four momenta
struct TestInPhaseSpaceLayout{MOM_TYPE<:AbstractTestMomentum} <:
       QEDbase.AbstractInPhaseSpaceLayout end
function Base.eltype(
    ::Type{PSL}
) where {MOM_TYPE<:AbstractTestMomentum,PSL<:TestInPhaseSpaceLayout{MOM_TYPE}}
    return MOM_TYPE
end
function Base.eltype(
    ::PSL
) where {MOM_TYPE<:AbstractTestMomentum,PSL<:TestInPhaseSpaceLayout{MOM_TYPE}}
    return MOM_TYPE
end

@inline QEDbase.phase_space_dimension(
    proc::AbstractProcessDefinition, ::AbstractModelDefinition, ::TestInPhaseSpaceLayout
) = 4 * number_incoming_particles(proc)

@inline function QEDbase._build_momenta(
    ::TestProcess, ::TestModel, in_psl::TestInPhaseSpaceLayout, in_coords
)
    return _groundtruth_in_moms(in_coords, eltype(in_psl))
end

# maps components of N-1 particles onto four-momenta and uses energy-momentum conservation
struct TestOutPhaseSpaceLayout{INPSL,MOM_TYPE} <: QEDbase.AbstractOutPhaseSpaceLayout{INPSL}
    in_psl::INPSL

    function TestOutPhaseSpaceLayout(
        in_psl::INPSL
    ) where {MOM_TYPE<:AbstractTestMomentum,INPSL<:TestInPhaseSpaceLayout{MOM_TYPE}}
        return new{INPSL,MOM_TYPE}(in_psl)
    end
end

function TestOutPhaseSpaceLayout(
    mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractTestMomentum}
    return TestOutPhaseSpaceLayout(TestInPhaseSpaceLayout{MOM_TYPE}())
end

function Base.eltype(
    ::Type{PSL}
) where {MOM_TYPE<:AbstractTestMomentum,INPSL,PSL<:TestOutPhaseSpaceLayout{INPSL,MOM_TYPE}}
    return MOM_TYPE
end
function Base.eltype(
    ::PSL
) where {MOM_TYPE<:AbstractTestMomentum,INPSL,PSL<:TestOutPhaseSpaceLayout{INPSL,MOM_TYPE}}
    return MOM_TYPE
end

@inline QEDbase.in_phase_space_layout(psl::TestOutPhaseSpaceLayout) = psl.in_psl

@inline QEDbase.phase_space_dimension(
    proc::AbstractProcessDefinition, ::AbstractModelDefinition, ::TestOutPhaseSpaceLayout
) = 4 * number_outgoing_particles(proc) - 4

@inline function QEDbase._build_momenta(
    proc::TestProcess,
    model::TestModel,
    in_moms::NTuple{NIN,AbstractFourMomentum},
    out_psl::TestOutPhaseSpaceLayout,
    out_coords,
) where {NIN}
    return _groundtruth_out_moms(in_moms, out_coords, eltype(out_psl))
end

struct TestInPhaseSpaceLayout_FAIL <: QEDbase.AbstractInPhaseSpaceLayout end
struct TestOutPhaseSpaceLayout_FAIL <:
       QEDbase.AbstractOutPhaseSpaceLayout{TestInPhaseSpaceLayout}
    in_psl::TestInPhaseSpaceLayout
end
function TestOutPhaseSpaceLayout_FAIL(
    mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractTestMomentum}
    return TestOutPhaseSpaceLayout_FAIL(TestInPhaseSpaceLayout{MOM_TYPE}())
end

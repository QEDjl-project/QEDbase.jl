
### Trivial phase-space layouts

# maps all components onto four momenta
struct TrivialInPSL <: QEDbase.AbstractInPhaseSpaceLayout end

@inline QEDbase.phase_space_dimension(
    proc::AbstractProcessDefinition, ::AbstractModelDefinition, ::TrivialInPSL
) = 4 * number_incoming_particles(proc)

@inline function QEDbase._build_momenta(
    ::TestProcess, ::TestModel, ::TrivialInPSL, in_coords
)
    return _groundtruth_in_moms(in_coords)
end

# maps componets of N-1 particles onto four-momenta and uses energy-momentum conservation
struct TrivialOutPSL <: QEDbase.AbstractOutPhaseSpaceLayout{TrivialInPSL}
    in_psl::TrivialInPSL
end

@inline QEDbase.in_phase_space_layout(psl::TrivialOutPSL) = psl.in_psl

@inline QEDbase.phase_space_dimension(
    proc::AbstractProcessDefinition, ::AbstractModelDefinition, ::TrivialOutPSL
) = 4 * number_outgoing_particles(proc) - 4

@inline function QEDbase._build_momenta(
    proc::TestProcess,
    model::TestModel,
    in_moms::NTuple{NIN,AbstractFourMomentum},
    out_psl::TrivialOutPSL,
    out_coords,
) where {NIN}
    return _groundtruth_out_moms(in_moms, out_coords)
end

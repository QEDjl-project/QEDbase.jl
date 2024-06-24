"""
    total_cross_section(in_psp::AbstractInPhaseSpacePoint)

Return the total cross section for a given [`AbstractInPhaseSpacePoint`](@ref).
"""
function total_cross_section(in_psp::AbstractInPhaseSpacePoint)
    I = 1 / (4 * _incident_flux(in_psp))
    return I * _total_probability(in_psp)
end

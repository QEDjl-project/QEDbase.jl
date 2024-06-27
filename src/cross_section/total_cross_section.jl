
############
# Total cross sections
############

"""
    total_cross_section(in_psp::InPhaseSpacePoint)

Return the total cross section for a given [`InPhaseSpacePoint`](@ref).
"""
function total_cross_section(in_psp::InPhaseSpacePoint)
    I = 1 / (4 * _incident_flux(in_psp))
    return I * _total_probability(in_psp)
end

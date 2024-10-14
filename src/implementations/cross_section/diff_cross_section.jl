########################
# differential and total cross sections.
#
# This file contains default implementations for differential
# cross sections based on the scattering process interface
########################

"""
    unsafe_differential_cross_section(phase_space_point::AbstractPhaseSpacePoint)

Return the differential cross section evaluated on a phase space point without checking if the given phase space is physical.
"""
function unsafe_differential_cross_section(phase_space_point::AbstractPhaseSpacePoint)
    I = 1 / (4 * _incident_flux(phase_space_point))

    return I * unsafe_differential_probability(phase_space_point)
end

"""
    differential_cross_section(phase_space_point::PhaseSpacePoint)

If the given phase spaces are physical, return differential cross section evaluated on a phase space point. Zero otherwise.
"""
function differential_cross_section(phase_space_point::AbstractPhaseSpacePoint)
    if !_is_in_phasespace(phase_space_point)
        # TODO: use the correct type here, i.e. implement a function `eltype` for psp or
        # make `momentum_type` an interface function.
        return zero(Float64)
    end

    return unsafe_differential_cross_section(phase_space_point)
end

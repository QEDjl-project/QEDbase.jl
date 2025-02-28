############
# scattering probabilities
#
# This file contains implementations of the scattering probability based on the
# process interface with and without input validation and/or phase space
# constraint.
############

# convenience function
# can be overloaded if an analytical version is known
function _matrix_element_square(psp::AbstractPhaseSpacePoint)
    mat_el = _matrix_element(psp)
    return abs2.(mat_el)
end

"""
    unsafe_differential_probability(phase_space_point::AbstractPhaseSpacePoint)

Return differential probability evaluated on a phase space point without checking if the given phase space(s) are physical.
"""
function unsafe_differential_probability(psp::AbstractPhaseSpacePoint)
    matrix_elements_sq = _matrix_element_square(psp)

    normalization = _averaging_norm(psp.proc)

    ps_fac = _phase_space_factor(psp)

    return normalization * sum(matrix_elements_sq) * ps_fac
end

"""
    differential_probability(phase_space_point::AbstractPhaseSpacePoint)

If the given phase spaces are physical, return differential probability evaluated on a phase space point. Zero otherwise.
"""
function differential_probability(phase_space_point::AbstractPhaseSpacePoint)
    if !_is_in_phasespace(phase_space_point)
        return zero(momentum_eltype(phase_space_point))
    end

    return unsafe_differential_probability(phase_space_point)
end

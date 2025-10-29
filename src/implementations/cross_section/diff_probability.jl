############
# scattering probabilities
#
# This file contains implementations of the scattering probability based on the
# process interface with and without input validation and/or phase space
# constraint.
############

"""
    _matrix_element_square(psp::AbstractPhaseSpacePoint)

Function that returns an `SVector` of squared matrix elements for the given [`PhaseSpacePoint`](@ref).
This function has a default implementation that uses [`_matrix_element`](@ref) and can be implemented instead of that function.
"""
@inline function _matrix_element_square(psp::AbstractPhaseSpacePoint)
    mat_el = _matrix_element(psp)
    return abs2.(mat_el)
end

"""
    _matrix_element_square_sum(psp::AbstractPhaseSpacePoint)

Function that returns the sum of squared matrix elements for a given [`PhaseSpacePoint`](@ref).
This function has a default implementation that uses [`_matrix_element_square`](@ref) and can be implemented instead of that function.
"""
@inline function _matrix_element_square_sum(psp::AbstractPhaseSpacePoint)
    return sum(_matrix_element_square(psp))
end

"""
    unsafe_differential_probability(phase_space_point::AbstractPhaseSpacePoint)

Return differential probability evaluated on a phase space point without checking if the given phase space(s) are physical.
"""
function unsafe_differential_probability(psp::AbstractPhaseSpacePoint)
    matrix_elements_sq_sum = _matrix_element_square_sum(psp)

    normalization = _averaging_norm(momentum_eltype(psp), psp.proc)

    ps_fac = _phase_space_factor(psp)

    return normalization * matrix_elements_sq_sum * ps_fac
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

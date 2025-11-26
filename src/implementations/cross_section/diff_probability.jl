############
# scattering probabilities
#
# This file contains implementations of the scattering probability based on the
# process interface with and without input validation and/or phase space
# constraint.
############
using KernelAbstractions

"""
    _matrix_element_square(psp::AbstractPhaseSpacePoint)

Function that returns an `SVector` of squared matrix elements for the given [`AbstractPhaseSpacePoint`](@ref).
This function has a default implementation that uses [`_matrix_element`](@ref) and can be implemented instead of that function.
"""
@inline function _matrix_element_square(psp::AbstractPhaseSpacePoint)
    mat_el = _matrix_element(psp)
    return abs2.(mat_el)
end

"""
    _matrix_element_square_sum(psp::AbstractPhaseSpacePoint)

Function that returns the sum of squared matrix elements for a given [`AbstractPhaseSpacePoint`](@ref).
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


# == KERNEL VERSIONS ==
"""
    @kernel function unsafe_differential_probability_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )

Broadcasting kernel definition using KernelAbstractions.jl for abstract phasespace points. This dispatches to the scalar implementation of [`unsafe_differential_probability`](@ref) and expects the given `dest` to contain the result type of that call on the given phase space points.
This function is dispatched to by [`unsafe_differential_probability!`](@ref) and should not be specialized (i.e. don't add methods to it). If a different implementation is required, specialize [`unsafe_differential_probability!`](@ref) instead.

!!! warn
    For performance reasons, this is tagged `inbounds = true`. In the kernel call, make sure that `ndrange = ` is set correctly (for example `length(psps)`) and that the given vectors have the same length.
"""
@kernel inbounds = true function unsafe_differential_probability_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )
    id = @index(Global)
    dest[id] = @inline unsafe_differential_probability(phase_space_points[id])
end

"""
    @kernel function differential_probability_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )

Broadcasting kernel definition using KernelAbstractions.jl for abstract phasespace points. This dispatches to the scalar implementation of [`differential_probability`](@ref) and expects the given `dest` to contain the result type of that call on the given phase space points.
This function is dispatched to by [`differential_probability!`](@ref) and should not be specialized (i.e. don't add methods to it). If a different implementation is required, specialize [`differential_probability!`](@ref) instead.

!!! warn
    For performance reasons, this is tagged `inbounds = true`. In the kernel call, make sure that `ndrange = ` is set correctly (for example `length(psps)`) and that the given vectors have the same length.
"""
@kernel inbounds = true function differential_probability_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )
    id = @index(Global)
    dest[id] = @inline differential_probability(phase_space_points[id])
end

# == VECTOR VERSIONS ==
"""
    function unsafe_differential_probability!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )

Vectorized version of [`unsafe_differential_probability`](@ref), writing the differential probability for each element in `phase_space_points` to the corresponding index in `dest`.

By default, this calls a generic KernelAbstractions kernel which dispatches to [`unsafe_differential_probability`](@ref), allowing the use of any of its backends (CPU, CUDA, AMDGPU, Metal, oneAPI).
This function can be specialized for specific processes. This should only be necessary when there is a specific reason to do so. Generally, implementing the basic process interface (see [`AbstractProcessDefinition`](@ref)) should be sufficient.
"""
function unsafe_differential_probability!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )
    @assert length(phase_space_points) == length(dest)
    @assert eltype(dest) <: AbstractFloat
    backend = get_backend(phase_space_points)
    unsafe_differential_probability_kernel!(backend)(dest, phase_space_points; ndrange = length(phase_space_points))
    return KernelAbstractions.synchronize(backend)
end

"""
    function differential_probability!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )

Vectorized version of [`differential_probability`](@ref), writing the differential probability for each element in `phase_space_points` to the corresponding index in `dest`.

By default, this calls a generic KernelAbstractions kernel which dispatches to [`differential_probability`](@ref), allowing the use of any of its backends (CPU, CUDA, AMDGPU, Metal, oneAPI).
This function can be specialized for specific processes. This should only be necessary when there is a specific reason to do so. Generally, implementing the basic process interface (see [`AbstractProcessDefinition`](@ref)) should be sufficient.
"""
function differential_probability!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )
    @assert length(phase_space_points) == length(dest)
    @assert eltype(dest) <: AbstractFloat
    backend = get_backend(phase_space_points)
    differential_probability_kernel!(backend)(dest, phase_space_points; ndrange = length(phase_space_points))
    return KernelAbstractions.synchronize(backend)
end

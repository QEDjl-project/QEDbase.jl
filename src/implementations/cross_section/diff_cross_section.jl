########################
# differential and total cross sections.
#
# This file contains default implementations for differential
# cross sections based on the scattering process interface
########################
using KernelAbstractions

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
        return zero(momentum_eltype(phase_space_point))
    end

    return unsafe_differential_cross_section(phase_space_point)
end

# == KERNEL VERSIONS ==
"""
    @kernel function unsafe_differential_cross_section_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )

Broadcasting kernel definition using KernelAbstractions.jl for abstract phasespace points. This dispatches to the scalar implementation of [`unsafe_differential_cross_section`](@ref) and expects the given `dest` to contain the result type of that call on the given phase space points.
This function is dispatched to by [`unsafe_differential_cross_section!`](@ref) and should not be specialized (i.e. don't add methods to it). If a different implementation is required, specialize [`unsafe_differential_cross_section!`](@ref) instead.

!!! warn
    For performance reasons, this is tagged `inbounds = true`. In the kernel call, make sure that `ndrange = ` is set correctly (for example `length(psps)`) and that the given vectors have the same length.
"""
@kernel inbounds = true function unsafe_differential_cross_section_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )
    id = @index(Global)
    dest[id] = @inline unsafe_differential_cross_section(phase_space_points[id])
end

"""
    @kernel function differential_cross_section_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )

Broadcasting kernel definition using KernelAbstractions.jl for abstract phasespace points. This dispatches to the scalar implementation of [`differential_cross_section`](@ref) and expects the given `dest` to contain the result type of that call on the given phase space points.
This function is dispatched to by [`differential_cross_section!`](@ref) and should not be specialized (i.e. don't add methods to it). If a different implementation is required, specialize [`differential_cross_section!`](@ref) instead.

!!! warn
    For performance reasons, this is tagged `inbounds = true`. In the kernel call, make sure that `ndrange = ` is set correctly (for example `length(psps)`) and that the given vectors have the same length.
"""
@kernel inbounds = true function differential_cross_section_kernel!(
        dest::AbstractVector,
        @Const(phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint}),
    )
    id = @index(Global)
    dest[id] = @inline differential_cross_section(phase_space_points[id])
end

# == VECTOR VERSIONS ==
"""
    function unsafe_differential_cross_section!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )

Vectorized version of [`unsafe_differential_cross_section`](@ref), writing the differential cross section for each element in `phase_space_points` to the corresponding index in `dest`.

By default, this calls a generic KernelAbstractions kernel which dispatches to [`unsafe_differential_cross_section`](@ref), allowing the use of any of its backends (CPU, CUDA, AMDGPU, Metal, oneAPI).
This function can be specialized for specific processes. This should only be necessary when there is a specific reason to do so. Generally, implementing the basic process interface (see [`AbstractProcessDefinition`](@ref)) should be sufficient.
"""
function unsafe_differential_cross_section!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )
    @assert length(phase_space_points) == length(dest)
    @assert eltype(dest) <: AbstractFloat
    backend = get_backend(phase_space_points)
    unsafe_differential_cross_section_kernel!(backend)(dest, phase_space_points; ndrange = length(phase_space_points))
    return KernelAbstractions.synchronize(backend)
end

"""
    function differential_cross_section!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )

Vectorized version of [`differential_cross_section`](@ref), writing the differential cross section for each element in `phase_space_points` to the corresponding index in `dest`.

By default, this calls a generic KernelAbstractions kernel which dispatches to [`differential_cross_section`](@ref), allowing the use of any of its backends (CPU, CUDA, AMDGPU, Metal, oneAPI).
This function can be specialized for specific processes. This should only be necessary when there is a specific reason to do so. Generally, implementing the basic process interface (see [`AbstractProcessDefinition`](@ref)) should be sufficient.
"""
function differential_cross_section!(
        dest::AbstractVector,
        phase_space_points::AbstractVector{<:AbstractPhaseSpacePoint},
    )
    @assert length(phase_space_points) == length(dest)
    @assert eltype(dest) <: AbstractFloat
    backend = get_backend(phase_space_points)
    differential_cross_section_kernel!(backend)(dest, phase_space_points; ndrange = length(phase_space_points))
    return KernelAbstractions.synchronize(backend)
end

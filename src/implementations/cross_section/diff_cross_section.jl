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
@kernel inbounds = true function unsafe_differential_cross_section_kernel(
        @Const(phase_space_points::AbstractVector{PSP}),
        dest::AbstractVector
    ) where {PSP <: AbstractPhaseSpacePoint}
    id = @index(Global)
    dest[id] = @inline unsafe_differential_cross_section(phase_space_points[id])
end

@kernel inbounds = true function differential_cross_section_kernel(
        @Const(phase_space_points::AbstractVector{PSP}),
        dest::AbstractVector
    ) where {PSP <: AbstractPhaseSpacePoint}
    id = @index(Global)
    dest[id] = @inline differential_cross_section(phase_space_points[id])
end

# == VECTOR VERSIONS ==
function unsafe_differential_cross_section(
        phase_space_points::AbstractVector{PSP},
        dest::AbstractVector
    ) where {PSP <: AbstractPhaseSpacePoint}
    @assert length(phase_space_points) == length(dest)
    backend = get_backend(phase_space_points)
    unsafe_differential_cross_section_kernel(backend)(phase_space_points, dest; ndrange = length(phase_space_points))
    return KernelAbstractions.synchronize(backend)
end

function differential_cross_section(
        phase_space_points::AbstractVector{PSP},
        dest::AbstractVector
    ) where {PSP <: AbstractPhaseSpacePoint}
    @assert length(phase_space_points) == length(dest)
    backend = get_backend(phase_space_points)
    differential_cross_section_kernel(backend)(phase_space_points, dest; ndrange = length(phase_space_points))
    return KernelAbstractions.synchronize(backend)
end


#############
# Implementations: Phase space layout
#############

### in ps layout

function _build_momenta(
    ::Val{Nc},
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_psl::AbstractInPhaseSpaceLayout,
    in_coords::NTuple{N},
) where {Nc,N}
    throw(
        InvalidInputError(
            "number of coordinates <$N> must be the same as the phase-space dimension <$Nc>"
        ),
    )
end

function _build_momenta(
    ::Val{Nc},
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_psl::AbstractInPhaseSpaceLayout,
    in_coords::NTuple{Nc,T},
) where {Nc,T}
    return _build_momenta(proc, model, in_psl, in_coords)
end

"""
    build_momenta(proc, model, in_psl::AbstractInPhaseSpaceLayout, in_coords::Tuple)

Construct the momenta of the incoming particles using the provided phase space coordinates.

This is the user-facing function that calls `_build_momenta` internally and validates the
number of coordinates against the phase space dimensionality.

# Arguments
- `proc`: The scattering process definition, subtype of [`AbstractProcessDefinition`](@ref).
- `model`: The physics model, subtype of [`AbstractModelDefinition`](@ref).
- `in_psl`: The incoming phase space layout, subtype of [`AbstractInPhaseSpaceLayout`](@ref).
- `in_coords`: A tuple of phase space coordinates that parametrize the incoming particle momenta.

# Returns
- A collection of four-momenta representing the incoming particles. Because of performance
    reasons, it is recommended to return a `Tuple` of four-momenta.
"""
function build_momenta(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_psl::AbstractInPhaseSpaceLayout,
    in_coords::Tuple,
)
    return _build_momenta(
        Val(phase_space_dimension(proc, model, in_psl)), proc, model, in_psl, in_coords
    )
end

"""
    build_momenta(proc::AbstractProcessDefinition, model::AbstractModelDefinition, in_psl::AbstractInPhaseSpaceLayout, in_coords::Real)

A scalar version of `build_momenta` for incoming phase space layouts (`in_psl`), where the phase space coordinates are provided as a single scalar instead of a tuple.

## Arguments:
- `proc`: The scattering process definition, subtype of [`AbstractProcessDefinition`](@ref).
- `model`: The physics model, subtype of [`AbstractModelDefinition`](@ref).
- `in_psl`: The incoming phase space layout, subtype of [`AbstractInPhaseSpaceLayout`](@ref).
- `in_coords::Real`: A single scalar representing the phase space coordinate for the
    incoming particles.

## Returns:
- A collection of four-momenta representing the incoming particles. For performance
    reasons, it is recommended to return a `Tuple` of four-momenta.

## Notes:
This function is a convenience wrapper around `build_momenta`, automatically converting the
scalar `in_coords` into a 1-tuple. It is useful when the incoming phase space only requires
a single coordinate to define the particle momenta.

"""
function build_momenta(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_psl::AbstractInPhaseSpaceLayout,
    in_coords::Real,
)
    return build_momenta(proc, model, in_psl, (in_coords,))
end

### out ps layout

function _build_momenta(
    ::Val{Nc},
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_moms::NTuple{NIN,<:AbstractFourMomentum},
    out_psl::AbstractOutPhaseSpaceLayout,
    out_coords::NTuple{N},
) where {Nc,N,NIN}
    throw(
        InvalidInputError(
            "number of coordinates <$N> must be the same as the out-phase-space dimension <$Nc>",
        ),
    )
end

function _build_momenta(
    ::Val{Nc},
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_moms::NTuple{NIN,<:AbstractFourMomentum},
    out_psl::AbstractOutPhaseSpaceLayout,
    out_coords::NTuple{Nc,T},
) where {Nc,NIN,T<:Real}
    return _build_momenta(proc, model, in_moms, out_psl, out_coords)
end

"""
    build_momenta(proc, model, Ptot::AbstractFourMomentum, out_psl::AbstractOutPhaseSpaceLayout, out_coords::Tuple)

Construct the momenta of the outgoing particles using the provided phase space coordinates (`out_coords`)
and total incoming momentum (`Ptot`).

This function ensures that the outgoing momenta satisfy energy and momentum conservation,
consistent with the physics model in use.

# Arguments
- `proc`: The scattering process definition, subtype of [`AbstractProcessDefinition`](@ref).
- `model`: The physics model, subtype of [`AbstractModelDefinition`](@ref).
- `in_moms`: The incoming four-momenta, used to compute the outgoing momenta.
- `out_psl`: The outgoing phase space layout, subtype of [`AbstractOutPhaseSpaceLayout](@ref).
- `out_coords`: A tuple of phase space coordinates that parametrize the outgoing particle momenta.

# Returns
- A collection of four-momenta representing the incoming particles. Because of performance
    reasons, it is recommened to return a `Tuple` of four-momenta.
"""
function build_momenta(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    in_moms::NTuple{NIN,<:AbstractFourMomentum},
    out_psl::AbstractOutPhaseSpaceLayout,
    out_coords::NTuple{Nc,T},
) where {Nc,NIN,T}
    return _build_momenta(
        Val(phase_space_dimension(proc, model, out_psl)),
        proc,
        model,
        in_moms,
        out_psl,
        out_coords,
    )
end

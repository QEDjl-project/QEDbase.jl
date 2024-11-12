
"""
    AbstractPhaseSpaceLayout

The `AbstractPhaseSpaceLayout` is an abstract type that represents the general concept of
a phase space layout in a scattering process.

## Interface Functions to Implement:
- `phase_space_dimension(proc, model, layout::AbstractPhaseSpaceLayout)`: Defines the number
    of independent phase space coordinates needed to build the momenta.
"""
abstract type AbstractPhaseSpaceLayout end

"""
    AbstractInPhaseSpaceLayout <: AbstractPhaseSpaceLayout

The `AbstractInPhaseSpaceLayout` represents the phase space layout for the incoming particles
in a scattering process. It defines the way in which the momenta of incoming particles are
constructed from phase space coordinates.

## Interface Functions to Implement:
- `phase_space_dimension(proc, model, layout::AbstractInPhaseSpaceLayout)`: Defines the number
    of independent phase space coordinates for the incoming particles.
- `build_momenta(proc, model, in_psl::AbstractInPhaseSpaceLayout, in_coords::Tuple)`: Constructs
    the momenta for the incoming particles using the phase space coordinates.
"""
abstract type AbstractInPhaseSpaceLayout <: AbstractPhaseSpaceLayout end

"""
    AbstractOutPhaseSpaceLayout{InPSL<:AbstractInPhaseSpaceLayout} <: AbstractPhaseSpaceLayout

The `AbstractOutPhaseSpaceLayout` represents the phase space layout for the outgoing particles
in a scattering process. It typically depends on the phase space layout of the incoming particles,
and it specifies how the momenta of the outgoing particles are constructed from the respective coordinates.

The generic parameter `InPSL` links the outgoing phase space layout to the incoming layout,
allowing consistency between the two configurations in the process.

## Interface Functions to Implement:
- `phase_space_dimension(proc, model, layout::AbstractOutPhaseSpaceLayout)`: Defines the
    number of independent phase space coordinates for the outgoing particles.
- `in_phase_space_layout(out_psl::AbstractOutPhaseSpaceLayout)`: Provides the associated
    incoming phase space layout to ensure consistency between incoming and outgoing configurations.
- `build_momenta(proc, model, Ptot::AbstractFourMomentum, out_psl::AbstractOutPhaseSpaceLayout, out_coords::Tuple)`:
    Constructs the momenta for the outgoing particles, ensuring they comply with energy and momentum conservation based on the total incoming four-momentum.
"""
abstract type AbstractOutPhaseSpaceLayout{InPSL<:AbstractInPhaseSpaceLayout} <:
              AbstractPhaseSpaceLayout end
"""
    phase_space_dimension(proc, model, layout::AbstractPhaseSpaceLayout) -> Int

This function needs to be implemented for the phase-space layout interface.
Return the dimensionality of the phase space, i.e., the number of coordinates, for a given
process and model within the specified `layout`.

The phase space dimension is a crucial quantity that determines how many independent coordinates
are required to describe the system of particles in the scattering process. It depends on
the number of particles involved and the specific interaction model in use.

## Arguments
- `proc`: The scattering process definition, a subtype of [`AbstractProcessDefinition`](@ref).
- `model`: The physics model, a subtype of [`AbstractModelDefinition`](@ref).
- `layout`: A specific phase space layout, either [`AbstractInPhaseSpaceLayout`](@ref) or
    [`AbstractOutPhaseSpaceLayout`](@ref).

## Returns
- The integer representing the number of independent phase space coordinates.

!!! note
    This function should return a compile-time constant, i.e., a number that
    can be inferred from the type information of the function call alone. If this
    is not the case, `build_momenta` and other derived functions may become
    very slow.
"""
function phase_space_dimension end

"""
    in_phase_space_layout(out_psl::AbstractOutPhaseSpaceLayout) -> AbstractInPhaseSpaceLayout

This function needs to be implemented for the [`AbstractOutPhaseSpaceLayout`](@ref) interface.
Given an outgoing phase space layout (`out_psl`), this function returns the associated incoming
phase space layout.

This is useful for ensuring consistency between the incoming and outgoing particle momenta
when calculating or sampling phase space points in scattering processes.


## Arguments
- `out_psl`: The outgoing phase space layout, a subtype of [`AbstractOutPhaseSpaceLayout`](@ref).

## Returns
- The associated incoming phase space layout, a subtype of [`AbstractInPhaseSpaceLayout`](@ref).
"""
function in_phase_space_layout end

"""
    _build_momenta(proc, model, in_psl::AbstractInPhaseSpaceLayout, in_coords::Tuple)
    _build_momenta(proc, model, Ptot::AbstractFourMomentum, out_psl::AbstractOutPhaseSpaceLayout, out_coords::Tuple)

These functions need to be implemented as part of the phase space layout interface for both
incoming and outgoing particle momenta construction. They serve as internal, low-level
interfaces for constructing the four-momenta of particles during a scattering process, and
are typically wrapped by the user-facing [`build_momenta`](@ref) function.

### Incoming Phase Space Layout
The first function, `_build_momenta(proc, model, in_psl, in_coords)`, constructs the
four-momenta for the incoming particles based on the specified phase space coordinates
(`in_coords`).

- **Arguments**:
    - `proc`: The scattering process definition, subtype of [`AbstractProcessDefinition`](@ref).
    - `model`: The physics model, subtype of [`AbstractModelDefinition`](@ref).
    - `in_psl`: The incoming phase space layout, subtype of [`AbstractInPhaseSpaceLayout`](@ref),
        that defines how to map the coordinates to momenta.
    - `in_coords`: A tuple of phase space coordinates that parametrize the momenta of the
        incoming particles.

- **Returns**:
    - A collection of four-momenta representing the incoming particles. For performance reasons,
        it is recommended to return a `Tuple` of four-momenta.

### Outgoing Phase Space Layout
The second function, `_build_momenta(proc, model, Ptot, out_psl, out_coords)`, constructs the
four-momenta for the outgoing particles. It uses the incoming four-momenta (`in_moms`) from the
incoming state and applies the phase space coordinates (`out_coords`) to compute the outgoing
momenta, ensuring they adhere to energy and momentum conservation laws.

- **Arguments**:
    - `proc`: The scattering process definition, subtype of [`AbstractProcessDefinition`](@ref).
    - `model`: The physics model, subtype of [`AbstractModelDefinition`](@ref).
    - `in_moms`: The incoming four-momenta, which is used to compute the momenta of the
        outgoing particles.
    - `out_psl`: The outgoing phase space layout, subtype of [`AbstractOutPhaseSpaceLayout`](@ref),
        that maps the coordinates to momenta.
    - `out_coords`: A tuple of phase space coordinates that parametrize the outgoing particle
        momenta.

- **Returns**:
    - A collection of four-momenta representing the outgoing particles. For performance reasons,
        it is recommended to return a `Tuple` of four-momenta.

### Notes
Both versions of `_build_momenta` handle the construction of particle momenta during different
phases of the scattering process:
- The **incoming version** constructs momenta based on phase space coordinates alone.
- The **outgoing version** constructs momenta based on both phase space coordinates and
    the total four-momentum, ensuring conservation laws are respected.
"""
function _build_momenta end

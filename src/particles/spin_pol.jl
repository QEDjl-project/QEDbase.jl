"""
Abstract base type for the spin or polarization of [`is_fermion`](@ref) or [`is_boson`](@ref) particles, respectively.
"""
abstract type AbstractSpinOrPolarization end
Base.broadcastable(spin_or_pol::AbstractSpinOrPolarization) = Ref(spin_or_pol)

"""
Abstract base type for the spin of [`is_fermion`](@ref) particles.
"""
abstract type AbstractSpin <: AbstractSpinOrPolarization end

"""
Abstract base type for definite spins of [`is_fermion`](@ref) particles.

Concrete types are [`SpinUp`](@ref) and [`SpinDown`](@ref).
"""
abstract type AbstractDefiniteSpin <: AbstractSpin end

"""
Abstract base type for indefinite spins of [`is_fermion`](@ref) particles.

One concrete type is [`AllSpin`](@ref).
"""
abstract type AbstractIndefiniteSpin <: AbstractSpin end

"""
Concrete type indicating that an [`is_fermion`](@ref) particle has spin-up.

```jldoctest
julia> using QEDbase

julia> SpinUp()
spin up
```
"""
struct SpinUp <: AbstractDefiniteSpin end
Base.show(io::IO, ::SpinUp) = print(io, "spin up")

"""
Concrete type indicating that an [`is_fermion`](@ref) particle has spin-down.

```jldoctest
julia> using QEDbase

julia> SpinDown()
spin down
```
"""
struct SpinDown <: AbstractDefiniteSpin end
Base.show(io::IO, ::SpinDown) = print(io, "spin down")

"""
Concrete type indicating that a particle with [`is_fermion`](@ref) has an indefinite spin and the differential cross section calculation should average or sum over all spins, depending on the direction ([`Incoming`](@ref) or [`Outgoing`](@ref)) of the particle in question.

```jldoctest
julia> using QEDbase

julia> AllSpin()
all spins
```
"""
struct AllSpin <: AbstractIndefiniteSpin end
Base.show(io::IO, ::AllSpin) = print(io, "all spins")

"""
    $(TYPEDSIGNATURES)

Utility function, which converts subtypes of [`AbstractDefiniteSpin`](@ref) into an integer representation, e.g. an index:

- `SpinUp`   ``\\rightarrow 1 ``
- `SpinDown` ``\\rightarrow 2``

This is useful in the implementation of some of [`base_state`](@ref)'s overloads.
"""
function _spin_index(::AbstractDefiniteSpin) end
_spin_index(::SpinUp) = 1
_spin_index(::SpinDown) = 2

"""
Abstract base type for the polarization of [`is_boson`](@ref) particles.
"""
abstract type AbstractPolarization <: AbstractSpinOrPolarization end

"""
Abstract base type for definite polarizations of [`is_boson`](@ref) particles.

Concrete types are [`PolarizationX`](@ref) and [`PolarizationY`](@ref).
"""
abstract type AbstractDefinitePolarization <: AbstractPolarization end

"""
Abstract base type for indefinite polarizations of [`is_boson`](@ref) particles.

One concrete type is [`AllPolarization`](@ref).
"""
abstract type AbstractIndefinitePolarization <: AbstractPolarization end

"""
Concrete type indicating that a particle with [`is_boson`](@ref) has an indefinite polarization and the differential cross section calculation should average or sum over all polarizations, depending on the direction ([`Incoming`](@ref) or [`Outgoing`](@ref)) of the particle in question.

```jldoctest
julia> using QEDbase

julia> AllPol()
all polarizations
```

!!! info "Alias"

    There is a built-in alias for `AllPolarization`:

    ```jldoctest
    julia> using QEDbase

    julia> AllPolarization === AllPol
    true
    ```
"""
struct AllPolarization <: AbstractIndefinitePolarization end
const AllPol = AllPolarization
Base.show(io::IO, ::AllPol) = print(io, "all polarizations")

"""
Concrete type which indicates, that a particle with [`is_boson`](@ref) has polarization in ``x``-direction.

```jldoctest
julia> using QEDbase

julia> PolX()
x-polarized
```

!!! note "Coordinate axes"

    The notion of axes, e.g. ``x``- and ``y``-direction is just to distinguish two orthogonal polarization directions.
    However, if the three-momentum of the [`is_boson`](@ref) particle is aligned to the ``z``-axis of a coordinate system, the polarization axes define the ``x``- or ``y``-axis, respectively.

!!! info "Alias"

    There is a built-in alias for `PolarizationX`:
    ```jldoctest
    julia> using QEDbase

    julia> PolarizationX === PolX
    true
    ```
"""
struct PolarizationX <: AbstractDefinitePolarization end
const PolX = PolarizationX
Base.show(io::IO, ::PolX) = print(io, "x-polarized")

"""
Concrete type which indicates, that an [`is_boson`](@ref) particle has polarization in ``y``-direction.

```jldoctest
julia> using QEDbase

julia> PolY()
y-polarized
```

!!! note "Coordinate axes"

    The notion of axes, e.g. ``x``- and ``y``-direction is just to distinguish two orthogonal polarization directions.
    However, if the three-momentum of the [`is_boson`](@ref) particle is aligned to the ``z``-axis of a coordinate system, the polarization axes define the ``x``- or ``y``-axis, respectively.

!!! info "Alias"

    There is a built-in alias for `PolarizationY`:
    ```jldoctest
    julia> using QEDbase

    julia> PolarizationY === PolY
    true
    ```
"""
struct PolarizationY <: AbstractDefinitePolarization end
const PolY = PolarizationY
Base.show(io::IO, ::PolY) = print(io, "y-polarized")

"""
    multiplicity(spin_or_pol)

Return the number of spins or polarizations respresented by `spin_or_pol`, e.g. `multiplicity(SpinUp()) == 1`, but `multiplicity(AllSpin()) = 2`.

"""
function multiplicity end
multiplicity(::AbstractDefinitePolarization) = 1
multiplicity(::AbstractDefiniteSpin) = 1
multiplicity(::AbstractIndefinitePolarization) = 2
multiplicity(::AbstractIndefiniteSpin) = 2

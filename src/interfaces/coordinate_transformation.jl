#######
# General coordinate transformations
#######

"""
    AbstractCoordinateTransformation

Abstract base type for coordinate transformations supposed to be acting on four-momenta.
Every subtype of `trafo::AbstractCoordinateTransformation` should implement the following interface functions:

* `QEDbase._transform(trafo,p)`: transforms `p`
* `Base.inv(trafo)`: returns the inverted transform

## Example

Implementing the interface by defining the interface functions:

```jldoctest trafo_interface
julia> using QEDbase

julia> struct TestTrafo{T} <: AbstractCoordinateTransformation
           a::T
       end

julia> QEDbase._transform(trafo::TestTrafo,p) = trafo.a*p

julia> Base.inv(trafo::TestTrafo) = TestTrafo(inv(trafo.a))

```

The `TestTrafo` can then be used to transform four-momenta:

```julia
julia> trafo = TestTrafo(2.0)
TestTrafo{Float64}(2.0)

julia> p = SFourMomentum(4,3,2,1)
4-element SFourMomentum with indices SOneTo(4):
 4.0
 3.0
 2.0
 1.0

julia> trafo(p) # multiply every component with 2.0
4-element SFourMomentum with indices SOneTo(4):
 8.0
 6.0
 4.0
 2.0

julia> inv(trafo)(p) # divide every component by 2.0
4-element SFourMomentum with indices SOneTo(4):
 2.0
 1.5
 1.0
 0.5
```
"""
abstract type AbstractCoordinateTransformation end
Base.broadcastable(trafo::AbstractCoordinateTransformation) = Ref(trafo)

"""
    _transform(trafo::AbstractCoordinateTransformation,p::AbstractFourMomentum)

Interface function for the application of the transformation to the four-momentum `p`.
Must return a four-momentum of the same type as `p`.
"""
function _transform end

# make the transform callable
@inline function (trafo::AbstractCoordinateTransformation)(p::AbstractFourMomentum)
    return _transform(trafo, p)
end

@inline function (trafo::AbstractCoordinateTransformation)(
    psf::PSF
) where {PSF<:AbstractParticleStateful}
    p_prime = _transform(trafo, momentum(psf))
    return PSF(p_prime)
end

@inline function (trafo::AbstractCoordinateTransformation)(
    psp::PSP
) where {PSP<:AbstractPhaseSpacePoint}
    in_moms = momenta(psp, Incoming())
    out_moms = momenta(psp, Outgoing())
    in_moms_prime = _transform.(trafo, in_moms)
    out_moms_prime = _transform.(trafo, out_moms)

    proc = process(psp)
    mod = model(psp)
    psl = phase_space_layout(psp)
    return constructorof(PSP)(proc, mod, psl, in_moms_prime, out_moms_prime)
end

#########
# Abstract Lorentz Boosts
#########

"""

    AbstractLorentzTransformation <: AbstractCoordinateTransformation

An abstract base type representing Lorentz transformations, which are coordinate
transformations between inertial and reference frames in special relativity.

`AbstractLorentzTransformation` extends `AbstractCoordinateTransformation` and provides
the foundational framework for all types of Lorentz transformations, including boosts.
These transformations preserve the Minkowski product of two four-vectors and are fundamental to
the description of relativistic physics, ensuring the laws of physics are the same in all
inertial frames.

"""
abstract type AbstractLorentzTransformation <: AbstractCoordinateTransformation end

"""

    AbstractLorentzBoost <: AbstractLorentzTransformation

An abstract base type representing Lorentz boosts, a specific type of Lorentz transformation
associated with relative motion between inertial frames along one or more spatial directions.

`AbstractLorentzBoost` extends `AbstractLorentzTransformation` and serves as the foundation
for all types of boost transformations in special relativity. Lorentz boosts describe how
four-vectors change when transitioning between two reference frames moving at constant velocities (in units of the speed of light) relative to each other.
"""
abstract type AbstractLorentzBoost <: AbstractLorentzTransformation end

"""

    AbstractBoostParameter

An abstract base type representing boost parameters used in Lorentz transformations, which
describe the relative motion between two inertial frames in special relativity.

`AbstractBoostParameter` serves as the foundation for defining specific boost parameters
that control Lorentz boosts in different spatial directions. Boost parameters typically
represent the velocity of one reference frame relative to another, expressed as a fraction
of the speed of light (`\\beta`), and are essential for performing Lorentz transformations
on four-vectors.

## Overview

In the context of special relativity, a Lorentz boost is a transformation that changes the
time and spatial components of a four-vector based on the relative motion between two
inertial reference frames. For example, the boost parameter ``\\beta`` is dimensionless and represents
this velocity as a fraction of the speed of light. Depending on the frame's relative velocity,
different forms of boost parameters exist, such as those associated with a single axis or
a vector describing boosts in multiple spatial dimensions.
"""
abstract type AbstractBoostParameter end

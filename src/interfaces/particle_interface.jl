###############
# The particle interface
#
# In this file, we define the interface for working with particles in a general
# sense. 
###############

"""
Abstract base type for every type which might be considered a *particle* in the context of `QED.jl`. For every (concrete) subtype of `AbstractParticle`, there are two kinds of interface functions implemented: static functions and property functions. 
The static functions provide information on what kind of particle it is (defaults are written in square brackets)

```julia
    is_fermion(::AbstractParticle)::Bool [= false]
    is_boson(::AbstractParticle)::Bool [= false]
    is_particle(::AbstractParticle)::Bool [= true]
    is_anti_particle(::AbstractParticle)::Bool [= false]
``` 
If the output of those functions differ from the defaults for a subtype of `AbstractParticle`, these functions need to be overwritten.
The second type of functions define a hard interface for `AbstractParticle`:

```julia
    mass(::AbstractParticle)::Real
    charge(::AbstractParticle)::Real
```
These functions must be implemented in order to have the subtype of `AbstractParticle` work with the functionalities of `QEDprocesses.jl`.
"""
abstract type AbstractParticle end

"""
    $(TYPEDSIGNATURES)

Interface function for particles. Return `true` if the passed subtype of [`AbstractParticle`](@ref) can be considered a *fermion* in the sense of particle statistics, and `false` otherwise.
The default implementation of `is_fermion` for every subtype of [`AbstractParticle`](@ref) will always return `false`.
"""
is_fermion(::AbstractParticle) = false

"""
    $(TYPEDSIGNATURES)

Interface function for particles. Return `true` if the passed subtype of [`AbstractParticle`](@ref) can be considered a *boson* in the sense of particle statistics, and `false` otherwise.
The default implementation of `is_boson` for every subtype of [`AbstractParticle`](@ref) will always return `false`.
"""
is_boson(::AbstractParticle) = false

"""
    $(TYPEDSIGNATURES)
    
Interface function for particles. Return `true` if the passed subtype of [`AbstractParticle`](@ref) can be considered a *particle* as distinct from anti-particles, and `false` otherwise.
The default implementation of `is_particle` for every subtype of [`AbstractParticle`](@ref) will always return `true`.
"""
is_particle(::AbstractParticle) = true

"""
    $(TYPEDSIGNATURES)

Interface function for particles. Return true if the passed subtype of [`AbstractParticle`](@ref) can be considered an *anti particle* as distinct from their particle counterpart, and `false` otherwise.
The default implementation of `is_anti_particle` for every subtype of [`AbstractParticle`](@ref) will always return `false`.
"""
is_anti_particle(::AbstractParticle) = false

"""
    mass(particle::AbstractParticle)::Real

Interface function for particles. Return the rest mass of a particle (in units of the electron mass).

This needs to be implemented for each concrete subtype of [`AbstractParticle`](@ref).
"""
function mass end

"""
    charge(::AbstractParticle)::Real

Interface function for particles. Return the electric charge of a particle (in units of the elementary electric charge).

This needs to be implemented for each concrete subtype of [`AbstractParticle`](@ref).
"""
function charge end

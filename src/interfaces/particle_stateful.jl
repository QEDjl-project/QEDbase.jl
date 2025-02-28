"""
    AbstractParticleStateful <: QEDbase.AbstractParticle

Abstract base type for the representation of a particle with a state. It requires the following interface functions to be provided:

- [`particle_direction`](@ref): Returning the particle's direction.
- [`particle_species`](@ref): Returning the particle's species.
- [`momentum`](@ref): Returning the particle's momentum.

Implementations for [`is_fermion`](@ref), [`is_boson`](@ref), [`is_particle`](@ref), [`is_anti_particle`](@ref), [`is_incoming`](@ref), [`is_outgoing`](@ref), [`mass`](@ref), and [`charge`](@ref) are automatically provided using the interface functions above to fulfill the [`QEDbase.AbstractParticle`](@ref) interface.
"""
abstract type AbstractParticleStateful{
    DIR<:ParticleDirection,SPECIES<:AbstractParticleType,ELEMENT<:AbstractFourMomentum
} <: AbstractParticle end

"""
    particle_direction(part::AbstractParticleStateful)

Interface function that must return the particle's [`ParticleDirection`](@ref).
"""
function particle_direction end

"""
    particle_species(part::AbstractParticleStateful)

Interface function that must return the particle's [`AbstractParticleType`](@ref), e.g. `QEDcore.Electron()`.
"""
function particle_species end

"""
    momentum(part::AbstractParticleStateful)

Interface function that must return the particle's [`AbstractFourMomentum`](@ref).
"""
function momentum end

# implement particle interface
@inline is_incoming(particle::AbstractParticleStateful) =
    is_incoming(particle_direction(particle))
@inline is_outgoing(particle::AbstractParticleStateful) =
    is_outgoing(particle_direction(particle))
@inline is_fermion(particle::AbstractParticleStateful) =
    is_fermion(particle_species(particle))
@inline is_boson(particle::AbstractParticleStateful) = is_boson(particle_species(particle))
@inline is_particle(particle::AbstractParticleStateful) =
    is_particle(particle_species(particle))
@inline is_anti_particle(particle::AbstractParticleStateful) =
    is_anti_particle(particle_species(particle))
@inline mass(particle::AbstractParticleStateful) = mass(particle_species(particle))
@inline charge(particle::AbstractParticleStateful) = charge(particle_species(particle))

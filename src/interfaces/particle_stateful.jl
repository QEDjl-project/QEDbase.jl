
abstract type AbstractParticleStateful{
    DIR<:ParticleDirection,SPECIES<:AbstractParticleType,ELEMENT<:AbstractFourMomentum
} <: AbstractParticle end

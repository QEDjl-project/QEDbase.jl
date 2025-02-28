# Phase Space Description

## Stateful Particles

```@docs
AbstractParticleStateful
momentum
momentum_type(::AbstractParticleStateful)
momentum_type(::Type{<:AbstractParticleStateful})
momentum_eltype(::AbstractParticleStateful)
momentum_eltype(::Type{<:AbstractParticleStateful{D,S,E}}) where {D,S,E}
```

## Phasespace Points

### Types

```@docs
AbstractPhaseSpacePoint
AbstractInPhaseSpacePoint
AbstractOutPhaseSpacePoint
```

### Interface

```@docs
process
model
phase_space_layout
```

### Convenience Functions

```@docs
particle_direction
particle_species
momenta
momentum_type(::AbstractPhaseSpacePoint)
momentum_type(::Type{<:AbstractPhaseSpacePoint{P,M,L,PS}}) where {P,M,L,PS}
momentum_eltype(::AbstractPhaseSpacePoint)
momentum_eltype(::Type{<:AbstractPhaseSpacePoint})
```

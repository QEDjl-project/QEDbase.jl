# Scattering Process Interface

## Process Interface

```@docs
AbstractProcessDefinition
incoming_particles
outgoing_particles
incoming_spin_pols
outgoing_spin_pols
```

## Particle Directions

```@docs
ParticleDirection
Incoming
Outgoing
UnknownDirection
is_incoming
is_outgoing
```

## Spins and Polarizations

```@docs
AbstractSpinOrPolarization
spin_pols_iter
```

### Spins

```@docs
AbstractSpin
AbstractDefiniteSpin
AbstractIndefiniteSpin
SpinUp
SpinDown
AllSpin
SyncedSpin
```

### Polarization

```@docs
AbstractPolarization
AbstractDefinitePolarization
AbstractIndefinitePolarization
PolarizationX
PolX
PolarizationY
PolY
AllPolarization
AllPol
SyncedPolarization
```

## Utility Functions

```@docs
number_incoming_particles
number_outgoing_particles
particles
number_particles
spin_pols
multiplicity
incoming_multiplicity
outgoing_multiplicity
```

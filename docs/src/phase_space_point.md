# What is a Phase Space Point?

In high-energy physics, a **phase space point** represents a specific configuration of
particles involved in a particle interaction or scattering process. More specifically,
it refers to the set of momenta (and possibly other quantum states) of all the incoming
and outgoing particles at a particular instant in the process.

For example, in a scattering process such as electron-positron annihilation:

```math
e^+ + e^- \to \gamma + \gamma
```

a phase space point would include the momenta (four-momenta, to be precise) of both the
incoming particles (the positron \(e^+\) and electron \(e^-\)) and the outgoing particles
(the two photons \(\gamma\)). Each phase space point can be thought of as a snapshot of
the physical state of the process at a given point in time.

## Why is it important?

In particle physics, calculations often involve integrating over all possible configurations
of momenta that satisfy certain conservation laws (like energy and momentum conservation).
The space of all these configurations is called the **phase space**, and each valid configuration
is a phase space point. These points play a central role in computing things like cross sections,
decay rates, and scattering amplitudes.

For any given process, we need a way to:

- Represent the particles and their momenta in the phase space.
- Ensure that the representation is consistent with the underlying physics (e.g., the correct
  number and type of particles, momentum conservation).
- Access the momenta of individual particles or compute derived quantities.

In [this tutorial](@ref tutorial_psp), we show how to create and use an `ExamplePhaseSpacePoint`,
following the interface specification given by [`AbstractPhaseSpacePoint`](@ref).

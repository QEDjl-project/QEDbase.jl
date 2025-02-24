# # [Tutorial: Implementing a New Particle Type](@id tutorial_particle)
#
# In this tutorial, we will implement a new particle type following the interface specification
# of `AbstractParticle` as used in `QuantumElectrodynamics.jl`. The `AbstractParticle` system
# has two main components:
#
# 1. **Static functions**: These functions determine the type of particle (fermion, boson, particle,
#    or anti-particle). They provide compile-time information about the particle type.
# 2. **Property functions**: These functions define the physical properties of the particle, such as mass and charge.
#
# ## Define a New Particle Species
#
# To start, we define a new concrete particle type that is a subtype of `AbstractParticleType`.
# For this example, we'll implement a new particle called `Muon`.
using QEDbase

# Define a new particle species as a subtype of AbstractParticleType
struct Muon <: AbstractParticleType end

# Since Muon is a subtype of AbstractParticleType, it is a singleton (no stateful properties).
# Implementing static functions for particle classification
QEDbase.is_fermion(::Muon) = true         # Muon is a fermion
QEDbase.is_boson(::Muon) = false          # Muon is not a boson
QEDbase.is_particle(::Muon) = true        # Muon is a particle (not an anti-particle)
QEDbase.is_anti_particle(::Muon) = false  # Muon is not an anti-particle

# ## Define Physical Properties
#
# Next, we need to define the required property functions for `mass` and `charge`.
# These functions return the mass and charge of the `Muon`.

# Define the physical properties of the Muon
QEDbase.mass(::Muon) = 105.66  # Muon mass in MeV/c^2
QEDbase.charge(::Muon) = -1.0  # Muon has a charge of -1 (same as electron)

# ## Anti-Particle Implementation (Optional)
#
# If we want to define the anti-particle of the muon (anti-muon), we can do that by defining
# another particle type and changing the static functions accordingly.

# Define the anti-particle of the Muon
struct AntiMuon <: AbstractParticleType end

# Implement static functions for the AntiMuon
QEDbase.is_fermion(::AntiMuon) = true        # AntiMuon is also a fermion
QEDbase.is_boson(::AntiMuon) = false         # AntiMuon is not a boson
QEDbase.is_particle(::AntiMuon) = false      # AntiMuon is not a regular particle (it's an anti-particle)
QEDbase.is_anti_particle(::AntiMuon) = true  # AntiMuon is an anti-particle

# Define the physical properties for the AntiMuon
QEDbase.mass(::AntiMuon) = 105.66  # AntiMuon has the same mass as Muon
QEDbase.charge(::AntiMuon) = 1.0   # AntiMuon has the opposite charge of Muon

# ## Example Usage
#
# Now we have both the `Muon` and its anti-particle (`AntiMuon`) implemented with the
# required interface functions. This makes these particles usable in `QuantumElectrodynamics.jl` processes.

# Create a muon and an anti-muon
mu = Muon()
anti_mu = AntiMuon()

# Access particle properties
println("Is Muon a fermion? ", is_fermion(mu))            # true
println("Is AntiMuon an anti-particle? ", is_anti_particle(anti_mu))  # true
println("Muon mass: ", mass(mu), " MeV/c^2")              # 105.66 MeV/c^2
println("AntiMuon charge: ", charge(anti_mu))             # +1.0

# ## Summary
#
# In this tutorial, we have demonstrated how to implement a new particle type in `QuantumElectrodynamics.jl`.
# By following the interface specification for `AbstractParticle`, we created:
#
# 1. A new particle (`Muon`) and defined its static functions (`is_fermion`, `is_boson`, etc.),
# 2. The required property functions (`mass` and `charge`),
# 3. An anti-particle (`AntiMuon`) with opposite charge and appropriate static functions.
#
# This setup makes these particles compatible with the rest of the `QuantumElectrodynamics.jl` framework
# and ready for use in particle physics simulations.

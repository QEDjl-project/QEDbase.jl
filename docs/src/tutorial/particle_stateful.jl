# # Tutorial: Implementing a Stateful Particle
#
# In this tutorial, we will extend particle types (like our `Muon` and `AntiMuon` from [the previous tutorial](@ref tutorial_particle))
# to implement **stateful particles**. A **stateful particle** is a particle that has runtime
# properties such as momentum, in addition to its compile-time species (like mass and charge).
#
# This tutorial will guide you through the implementation of `AbstractParticleStateful` by
# creating stateful versions of particle types.
#
# ## Define a Stateful Particle Type
#
# To start, we need to define a concrete subtype of `AbstractParticleStateful`. A stateful particle must store information such as:
#
# - **Direction**: Incoming or outgoing (`ParticleDirection`).
# - **Species**: The type of particle (`AbstractParticleType`).
# - **Momentum**: The four-momentum of the particle (`AbstractFourMomentum`).
#
# We will define a general `ExampleParticleStateful` type that can take any particle species as a type parameter.
# This type will also store the direction (incoming or outgoing) and the particle's four-momentum.
using QEDbase

# Define a general stateful particle type that works for any particle species
struct ExampleParticleStateful{
    DIR<:ParticleDirection,SPECIES<:AbstractParticleType,ELEMENT<:AbstractFourMomentum
} <: AbstractParticleStateful{DIR,SPECIES,ELEMENT}
    direction::DIR        # Incoming or outgoing
    species::SPECIES      # Particle species (e.g., Muon, AntiMuon)
    mom::ELEMENT          # Particle's four-momentum
end

# ## Implement the Interface Functions
#
# Next, we implement the required interface functions for `ExampleParticleStateful`, which are:
#
# - [`particle_direction`](@ref)
# - [`particle_species`](@ref)
# - [`momentum`](@ref)
#
# These functions extract the respective properties from the `ExampleParticleStateful` object.

# Define the particle_direction function
function particle_direction(part::ExampleParticleStateful)
    return part.direction
end

# Define the particle_species function
function particle_species(part::ExampleParticleStateful)
    return part.species
end

# Define the momentum function
function momentum(part::ExampleParticleStateful)
    return part.mom
end

# ## Example Usage
#
# We can now create instances of `ExampleParticleStateful` for, say, `Electron` and `Positron`.
using QEDcore  # to get predefined particles and four-momentum

# Create a four-momentum vector (dummy example)
momentum_electron = SFourMomentum(1.0, 0.0, 0.0, 0.0);  # E, px, py, pz

# Create an incoming Electron using ExampleParticleStateful
incoming_electron = ExampleParticleStateful(Incoming(), Electron(), momentum_electron);

# Create an outgoing Positron using ExampleParticleStateful
outgoing_positron = ExampleParticleStateful(Outgoing(), Positron(), momentum_electron);

# Access particle properties
println("Incoming electron mass: ", mass(particle_species(incoming_electron)))
println(
    "Is the outgoing positron a fermion? ", is_fermion(particle_species(outgoing_positron))
)

# Access momentum
println("Incoming electron momentum: ", momentum(incoming_electron))
println("Outgoing positron momentum: ", momentum(outgoing_positron))

# ## Summary
#
# In this tutorial, we created a general `ExampleParticleStateful` type that can represent any particle species (like `Electron`,`Positron` from `QEDcore`, but also `Muon` or `AntiMuon` implemented in [this tutorial](@ref tutorial_particle)) by using the species as a type parameter. This approach avoids the need to define separate stateful types for each particle, making the implementation more flexible and reusable.
#
# The key steps were:
#
# 1. **Defining the general `ExampleParticleStateful` type** with parameters for direction, species, and momentum.
# 2. **Implementing the interface functions** to retrieve direction, species, and momentum.
# 3. **Using the generalized type** for all subtypes of `AbstractParticleType`.
#
# This method makes it easy to add more particles in the future while keeping the same structure.
# !!! note "Reference implementation"
#
#     A reference implementation of a stateful particle type is given by
#     [`QEDcore.ParticleStateful`](@extref)

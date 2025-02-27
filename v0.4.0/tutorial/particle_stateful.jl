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
function QEDbase.particle_direction(part::ExampleParticleStateful)
    return part.direction
end

# Define the particle_species function
function QEDbase.particle_species(part::ExampleParticleStateful)
    return part.species
end

# Define the momentum function
function QEDbase.momentum(part::ExampleParticleStateful)
    return part.mom
end

# ## Example Usage
#
# We can now create instances of `ExampleParticleStateful` for, say, `Muon` and `AntiMuon`.

redirect_stdout(devnull) do # hide
    include(joinpath(dirname(Base.active_project()), "src", "tutorial", "particle.jl"))          # to get predefined particles
    include(joinpath(dirname(Base.active_project()), "src", "tutorial", "four_momentum.jl"))     # to get custom four momentum vector
end # hide

# Create a four-momentum vector (dummy example)
momentum_muon = CustomFourMomentum(1.0, 0.0, 0.0, 0.0);  # E, px, py, pz

# Create an incoming Muon using ExampleParticleStateful
incoming_muon = ExampleParticleStateful(Incoming(), Muon(), momentum_muon);

# Create an outgoing AntiMuon using ExampleParticleStateful
outgoing_antimuon = ExampleParticleStateful(Outgoing(), AntiMuon(), momentum_muon);

# Access particle properties
println("Incoming muon mass: ", mass(particle_species(incoming_muon)))
println(
    "Is the outgoing antimuon a fermion? ", is_fermion(particle_species(outgoing_antimuon))
)

# Access momentum
println("Incoming muon momentum: ", momentum(incoming_muon))
println("Outgoing antimuon momentum: ", momentum(outgoing_antimuon))

# ## Summary
#
# In this tutorial, we created a general `ExampleParticleStateful` type that can represent any particle species 
# (like `Muon` or `AntiMuon` implemented in [this tutorial](@ref tutorial_particle), but also [`Electron`](@extref QEDcore.Electron) and 
# [`Positron`](@extref QEDcore.Positron) from `QEDcore`) by using the species as a type parameter. This approach avoids the need to define 
# separate stateful types for each particle, making the implementation more flexible and reusable.
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
#     [`ParticleStateful`](@extref :jl:type:`QEDcore.ParticleStateful`)

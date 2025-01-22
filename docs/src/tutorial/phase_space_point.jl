# # Define a Custom Phase Space Point
#
# In this tutorial, we will define a custom **phase space point** type following the interface
# specification used in `QuantumElectrodynamics.jl`.
#
# The `AbstractPhaseSpacePoint` system has three key components:
#
# 1. **Scattering process:** The definition of the process, which includes the incoming and outgoing particles.
# 2. **Computational model:** The physics model, such as Quantum Electrodynamics (QED), that governs the dynamics of the particles.
# 3. **Phase space definition:** The structure used to create phase space points from coordinates in the multidimensional phase space.
#
# By the end of this tutorial, we’ll implement and test a custom phase space point using the **electron-positron annihilation** process:
#
# ```math
# e^+ + e^- \rightarrow \gamma + \gamma
# ```

# ## Step 0: Import the Necessary Ingredients
# We'll begin by importing necessary functionality from `QEDbase`, the muon and anti-muon particles from the
# particles tutorial, and the `ParticleStateful` from its respective tutorial.

using QEDbase

#!format: off
redirect_stdout(devnull) do # hide
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "particle.jl"))          # to get predefined particles
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "particle_stateful.jl")) # to get custom particle stateful definition
end # hide
#!format: on

# We'll also need a `Photon` type which we briefly define right here.

struct Photon <: AbstractParticleType end
QEDbase.is_boson(::Photon) = true
QEDbase.is_particle(::Photon) = true
QEDbase.is_anti_particle(::Photon) = true
QEDbase.mass(::Photon) = 0.0
QEDbase.charge(::Photon) = 0.0

# ## Step 1: Define an Example Process
# We define a process that describes muon-anti-muon annihilation. This process will involve
# two incoming particles (a muon and an anti-muon) and two outgoing particles (two photons).

struct ExampleProcess <: AbstractProcessDefinition end

# Next, we specify the incoming and outgoing particles for the process by overloading the required interface functions:

# ### Define Incoming and Outgoing Particles
# The incoming particles are a muon and an anti-muon, and the outgoing particles are two photons.

function QEDbase.incoming_particles(::ExampleProcess)
    return (Muon(), AntiMuon())  # These particle types are defined in the particles tutorial.
end

function QEDbase.outgoing_particles(::ExampleProcess)
    return (Photon(), Photon())  # Photons are defined above. They are also properly defined in QEDcore.
end

# At this point, we have defined our `ExampleProcess` with the required particles.

# ## Step 2: Implement the Model
# Next, we define a simple computational model, which will govern the behavior of the particles during the interaction.

struct ExampleModel <: AbstractModelDefinition end

# This model can later be extended to incorporate complex QED interactions, but for now, we use it as a placeholder.

# ## Step 3: Define Phase Space Layout
# The last part we need to implement is a phase space layout which describes the
# coordinate structure of the phase space:

struct ExamplePhaseSpaceLayout <: AbstractPhaseSpaceLayout end

# This phase space layout can be extended later, but for now this is also a placeholder.

# ## Step 4: Define an Example Phase Space Point
# We now define the `ExamplePhaseSpacePoint` type, which will represent a specific point
# in the phase space of the muon-anti-muon annihilation process. This type holds the process,
# the model, the phase space definition, and the incoming and outgoing particles.

struct ExamplePhaseSpacePoint{PROC,MODEL,PSL,IN_PARTICLES,OUT_PARTICLES} <:
       AbstractPhaseSpacePoint{PROC,MODEL,PSL,IN_PARTICLES,OUT_PARTICLES}
    proc::PROC
    mdl::MODEL
    psl::PSL
    in_particles::IN_PARTICLES
    out_particles::OUT_PARTICLES
end

# ## Step 5: Implement the Interface Functions
# Now, we implement the interface functions required by `AbstractPhaseSpacePoint`. These include
# functions for retrieving the process, model, phase space definition, and particle information.

function QEDbase.process(psp::ExamplePhaseSpacePoint)
    return psp.proc
end

function QEDbase.model(psp::ExamplePhaseSpacePoint)
    return psp.mdl
end

function QEDbase.phase_space_layout(psp::ExamplePhaseSpacePoint)
    return psp.psl
end

function QEDbase.particles(psp::ExamplePhaseSpacePoint, dir::ParticleDirection)
    if dir == Incoming()
        return psp.in_particles
    elseif dir == Outgoing()
        return psp.out_particles
    else
        throw(ArgumentError("Invalid particle direction"))
    end
end

function Base.getindex(psp::ExamplePhaseSpacePoint, dir::ParticleDirection, n::Int)
    return particles(psp, dir)[n]
end

# With these functions, we can now retrieve the process, model, phase space definition,
# and individual particles from our `ExamplePhaseSpacePoint`.

# ## Step 6: Access momenta
# The particles involved in the process have associated four-momenta, which describe their
# energy and momentum in spacetime. Let’s implement the functions to retrieve the momenta
# of particles.

# Return the momentum of a specific particle
function QEDbase.momentum(psp::ExamplePhaseSpacePoint, dir::ParticleDirection, n::Int)
    return momentum(particles(psp, dir)[n])
end

# Return a tuple of all momenta in a given direction
function QEDbase.momenta(psp::ExamplePhaseSpacePoint, dir::ParticleDirection)
    return ntuple(i -> momentum(psp, dir, i), length(particles(psp, dir)))
end

# ## Step 7: Test the Implementation
# Finally, we’ll test our implementation using the **muon-anti-muon annihilation** process.
#
# 1. Create an instance of the process (`ExampleProcess`).
# 2. Create an instance of the model (`ExampleModel`).
# 3. Define the phase space layout (`ExamplePhaseSpaceLayout`).
# 4. Define the incoming and outgoing particles, specifying their four-momenta.
# 5. Create the phase space point and compute the momenta.

proc = ExampleProcess()
model = ExampleModel()
psl = ExamplePhaseSpaceLayout()

in_particles = (
    ExampleParticleStateful(Incoming(), Muon(), CustomFourMomentum(1.0, 0.0, 0.0, 1.0)),
    ExampleParticleStateful(
        Incoming(), AntiMuon(), CustomFourMomentum(1.0, 0.0, 0.0, -1.0)
    ),
)

out_particles = (
    ExampleParticleStateful(Outgoing(), Photon(), CustomFourMomentum(1.0, 1.0, 0.0, 0.0)),
    ExampleParticleStateful(Outgoing(), Photon(), CustomFourMomentum(1.0, -1.0, 0.0, 0.0)),
)

psp = ExamplePhaseSpacePoint(proc, model, psl, in_particles, out_particles)

incoming_momenta = momenta(psp, Incoming())
outgoing_momenta = momenta(psp, Outgoing())

println("Incoming momenta: ", incoming_momenta)
println("Outgoing momenta: ", outgoing_momenta)

# ## Conclusion
#
# We have successfully defined a custom phase space point type, implemented the necessary interface functions,
# and verified the momenta for a muon-anti-muon annihilation process.
# This phase space point system provides a flexible way to work with scattering processes.

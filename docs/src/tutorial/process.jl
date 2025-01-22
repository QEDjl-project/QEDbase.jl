# # Tutorial: Defining a Custom Scattering Process
#
# In this tutorial, we'll define a custom scattering process by following the interface for [`AbstractProcessDefinition`](@ref).
# We'll cover the necessary functions, including particle types, spin and polarization handling, and matrix element calculations.

# ## Step 1: Define a Custom Process Type
#
# Start by creating a custom type that inherits from `AbstractProcessDefinition`.
# This type will represent your process, for example, muon-anti-muon scattering into two photons.

using QEDbase

#!format: off
redirect_stdout(devnull) do # hide
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "particle.jl"))          # to get predefined particles
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "model.jl"))             # to get the custom model
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "four_momentum.jl"))     # to get the custom four momenta
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "phase_space_point.jl")) # to get the custom phase space points
end # hide
#!format: on

# Define a specific process by creating a subtype of `AbstractProcessDefinition`:
struct MyProcess <: AbstractProcessDefinition
    ## Add relevant information, such as particle or any other process-specific properties.
    incoming_particles::Tuple
    outgoing_particles::Tuple
end

# ## Step 2: Implement Required Particle Accessor Functions
#
# Every process must define the `incoming_particles` and `outgoing_particles` functions to list the particles involved.
# These functions return tuples of particles.

QEDbase.incoming_particles(proc::MyProcess) = proc.incoming_particles
QEDbase.outgoing_particles(proc::MyProcess) = proc.outgoing_particles

# ## Step 3: Handle Spins and Polarizations
#
# To define the spin and polarization for the particles, overload `incoming_spin_pols` and `outgoing_spin_pols`.
# For our custom process, we assume average/summation over all spins and polarizations.
# However, you can define specific spins or polarizations if needed.

QEDbase.incoming_spin_pols(::MyProcess) = (AllSpin(), AllSpin())  # Both incoming particles are fermions (muon and antimuon)
QEDbase.outgoing_spin_pols(::MyProcess) = (AllPolarization(), AllPolarization())  # Photons are boson

# ## Step 4: Define the Matrix Element Calculation
#
# The matrix element is a central part of any scattering process. It needs to be implemented for each spin and polarization combination.
# To calculate matrix elements, you must define the `_matrix_element` function.

function QEDbase._matrix_element(psp::AbstractPhaseSpacePoint{MyProcess})
    ## Calculate the matrix element for the specific process.
    ## This is a placeholder for the actual computation.
    return 1.0  # Placeholder value
end

# ## Step 5: Define Incident Flux
#
# To compute the cross section, we need to define the incident flux.
# This function calculates the initial flux of incoming particles, based on their momenta and energies.

function QEDbase._incident_flux(psp::AbstractInPhaseSpacePoint{MyProcess})
    ## Placeholder calculation for incident flux
    return 1.0  # Placeholder value
end

# ## Step 6: Averaging Over Spin and Polarization
#
# Define the `_averaging_norm` function to return the normalization factor used to average the squared matrix elements over spins and polarizations.

function QEDbase._averaging_norm(proc::MyProcess)
    ## For example, if both incoming particles are fermions, the normalization could be the product of their spin multiplicity, i.e. 2 times 2.
    return 4  # Placeholder value
end

# ## Step 7: Check for Physical Phase Space
#
# The `_is_in_phasespace` function verifies whether a particular combination of incoming and outgoing momenta is physically allowed (on-shell, momentum conservation, etc.).

function QEDbase._is_in_phasespace(psp::AbstractPhaseSpacePoint{MyProcess})
    ## Implement energy-momentum conservation and on-shell conditions.
    return true  # Placeholder value
end

# ## Step 8: Define the Phase Space Factor
#
# To calculate cross sections, define the `_phase_space_factor` function, which returns the pre-differential factor of the invariant phase space integral measure.

function QEDbase._phase_space_factor(psp::AbstractPhaseSpacePoint{MyProcess})
    ## Return the phase space factor
    return 1.0  # Placeholder value
end

# ## Step 9: Optional - Total Probability Calculation
#
# Optionally, you can define the `_total_probability` function to compute the total probability of the process.
# This is especially useful when computing total cross sections.

function QEDbase._total_probability(psp::AbstractPhaseSpacePoint{MyProcess})
    ## Calculate the total probability for the process
    return 1.0  # Placeholder value
end

# ## Putting It All Together
#
# After defining the required functions, you now have a complete process definition for `MyProcess`.
# This process can be used in phase space integration, cross section calculation, and other scattering computations in `QuantumElectrodynamics.jl`.
#
# For example, if your process is muon-anti-muon scattering into two photons:

particles_in = (Muon(), AntiMuon())
particles_out = (Photon(), Photon())
process = MyProcess(particles_in, particles_out)

# You can then access the particles as follows:

println("incoming particles: ", incoming_particles(process))
println("outgoing particles: ", outgoing_particles(process))

# You can define some momenta for the incoming and outgoing particles

muon_mass = mass(Muon())
muon_momentum = CustomFourMomentum(500.0, 0, 0, sqrt(500.0^2 - muon_mass^2))
antimuon_momentum = CustomFourMomentum(500.0, 0, 0, -sqrt(500.0^2 - muon_mass^2))
incoming_momenta = (muon_momentum, antimuon_momentum)
photon_momentum1 = CustomFourMomentum(500.0, 500.0, 0, 0)
photon_momentum2 = CustomFourMomentum(500.0, -500.0, 0, 0)
outgoing_momenta = (photon_momentum1, photon_momentum2)

# And you can define phase space layouts and computational models (here just as
# placeholder):

psl = ExamplePhaseSpaceLayout()
model = CustomModel()

# Finally, you can build a phase space point for your process

incoming_ps =
    ExampleParticleStateful.(Incoming(), incoming_particles(process), incoming_momenta)
outgoing_ps =
    ExampleParticleStateful.(Outgoing(), outgoing_particles(process), outgoing_momenta)

psp = ExamplePhaseSpacePoint(process, model, psl, incoming_ps, outgoing_ps)

# For this phase space point, the differential cross section can be calculated by calling

println("differential cross section: ", differential_cross_section(psp))

# # Tutorial: Defining a Custom Scattering Process
#
# In this tutorial, we'll define a custom scattering process by following the interface for [`AbstractProcessDefinition`](@ref).
# We'll cover the necessary functions, including particle types, spin and polarization handling, and matrix element calculations.

# ## Step 1: Define a Custom Process Type
#
# Start by creating a custom type that inherits from `AbstractProcessDefinition`.
# This type will represent your process, for example, electron-positron scattering into two photons.

using QEDbase
using QEDcore # for particle definitions and phase space points

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

QEDbase.incoming_spin_pols(::MyProcess) = (AllSpin(), AllSpin())  # Both incoming particles are fermions (electron and positron)
QEDbase.outgoing_spin_pols(::MyProcess) = (AllPolarization(), AllPolarization())  # Photons are boson

# ## Step 4: Define the Matrix Element Calculation
#
# The matrix element is a central part of any scattering process. It needs to be implemented for each spin and polarization combination.
# To calculate matrix elements, you must define the `_matrix_element` function.

function QEDbase._matrix_element(psp::PhaseSpacePoint{MyProcess})
    ## Calculate the matrix element for the specific process.
    ## This is a placeholder for the actual computation.
    return 1.0  # Placeholder value
end

# ## Step 5: Define Incident Flux
#
# To compute the cross section, we need to define the incident flux.
# This function calculates the initial flux of incoming particles, based on their momenta and energies.

function QEDbase._incident_flux(psp::InPhaseSpacePoint{MyProcess})
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

function QEDbase._is_in_phasespace(psp::PhaseSpacePoint{MyProcess})
    ## Implement energy-momentum conservation and on-shell conditions.
    return true  # Placeholder value
end

# ## Step 8: Define the Phase Space Factor
#
# To calculate cross sections, define the `_phase_space_factor` function, which returns the pre-differential factor of the invariant phase space integral measure.

function QEDbase._phase_space_factor(psp::PhaseSpacePoint{MyProcess})
    ## Return the phase space factor
    return 1.0  # Placeholder value
end

# ## Step 9: Optional - Total Probability Calculation
#
# Optionally, you can define the `_total_probability` function to compute the total probability of the process.
# This is especially useful when computing total cross sections.

function QEDbase._total_probability(psp::PhaseSpacePoint{MyProcess})
    ## Calculate the total probability for the process
    return 1.0  # Placeholder value
end

# ## Putting It All Together
#
# After defining the required functions, you now have a complete process definition for `MyProcess`.
# This process can be used in phase space integration, cross section calculation, and other scattering computations in `QuantumElectrodynamics.jl`.
#
# For example, if your process is electron-positron scattering into two photons:

using QEDprocesses # for a predefined model: PerturbativeQED

particles_in = (Electron(), Positron())
particles_out = (Photon(), Photon())
process = MyProcess(particles_in, particles_out)

# You can then access the particles as follows:

println("incoming particles: ", incoming_particles(process))
println("outgoing particles: ", outgoing_particles(process))

# You can define some momenta for the incoming and outgoing particles

electron_mass = mass(Electron())
electron_momentum = SFourMomentum(3.0, 0, 0, sqrt(3.0^2 - electron_mass^2))
positron_momentum = SFourMomentum(3.0, 0, 0, -sqrt(3.0^2 - electron_mass^2))
incoming_momenta = (electron_momentum, positron_momentum)
photon_momentum1 = SFourMomentum(3.0, 3.0, 0, 0)
photon_momentum2 = SFourMomentum(3.0, -3.0, 0, 0)
outgoing_momenta = (photon_momentum1, photon_momentum2)

# And you can define phase space definitions and computational models (here just as
# placeholder):

ps_def = PhasespaceDefinition(SphericalCoordinateSystem(), CenterOfMomentumFrame())
model = PerturbativeQED()

# Finally, you can build a phase space point for your process

psp = PhaseSpacePoint(process, model, ps_def, incoming_momenta, outgoing_momenta)

# For this phase space point, the differential cross section can be calculated by calling

println("differential cross section: ", differential_cross_section(psp))

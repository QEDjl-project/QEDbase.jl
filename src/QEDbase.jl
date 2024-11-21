module QEDbase

export minkowski_dot, mdot, register_LorentzVectorLike
export getT, getX, getY, getZ
export getMagnitude2, getMag2, getMagnitude, getMag
export getInvariantMass2, getMass2, getInvariantMass, getMass
export getE, getEnergy, getPx, getPy, getPz
export getBeta, getGamma
export getTransverseMomentum2, getPt2, getPerp2, getTransverseMomentum, getPt, getPerp
export getTransverseMass2, getMt2, getTransverseMass, getMt
export getRapidity
export getRho2, getRho
export getTheta, getCosTheta
export getPhi, getCosPhi, getSinPhi
export getPlus, getMinus

export setE!, setEnergy!, setPx!, setPy!, setPz!
export setTheta!, setCosTheta!, setRho!, setPhi!
export setPlus!, setMinus!
export setTransverseMomentum!, setPerp!, setPt!
export setTransverseMass!, setMt!
export setRapidity!

export AbstractLorentzVector, dot
export AbstractFourMomentum
export isonshell, assert_onshell

export AbstractDiracVector, AbstractDiracMatrix

export AbstractGammaRepresentation

# particle interface
export AbstractParticle, AbstractParticleType
export is_fermion, is_boson, is_particle, is_anti_particle
export mass, charge
export base_state, propagator

# directions
export ParticleDirection, Incoming, Outgoing, UnknownDirection
export is_incoming, is_outgoing

# polarizations and spins
export AbstractSpinOrPolarization, AbstractPolarization, AbstractSpin
export AbstractDefinitePolarization, AbstractIndefinitePolarization
export PolarizationX, PolX, PolarizationY, PolY, AllPolarization, AllPol
export AbstractDefiniteSpin, AbstractIndefiniteSpin
export SpinUp, SpinDown, AllSpin
export SyncedSpin, SyncedPolarization, SyncedPol
export spin_pols_iter

# probabilities
export differential_probability, unsafe_differential_probability
export total_probability

# differential cross section
export differential_cross_section, unsafe_differential_cross_section
export total_cross_section

# Abstract model interface
export AbstractModelDefinition, fundamental_interaction_type

# Abstract process interface
export AbstractProcessDefinition, incoming_particles, outgoing_particles
export number_incoming_particles, number_outgoing_particles
export particles, number_particles
export incoming_spin_pols, outgoing_spin_pols, spin_pols
export multiplicity, incoming_multiplicity, outgoing_multiplicity

# Abstract phase space layout
#export AbstractPhaseSpaceLayout
#export AbstractInPhaseSpaceLayout
#export AbstractOutPhaseSpaceLayout
#export build_momenta, phase_space_dimension, in_phase_space_layout

# Abstract phase space definition interface
export AbstractCoordinateSystem, AbstractFrameOfReference, AbstractPhasespaceDefinition

# Abstract phase space point interface
export AbstractParticleStateful, AbstractPhaseSpacePoint
export particle_direction, particle_species, momentum
export process, model, phase_space_definition, momenta
export AbstractInPhaseSpacePoint, AbstractOutPhaseSpacePoint

# Abstract coordinate transformation interface
export AbstractCoordinateTransformation

# errors
export InvalidInputError, RegistryError, OnshellError, SpinorConstructionError

using StaticArrays
using LinearAlgebra
using DocStringExtensions

using SimpleTraits
using ArgCheck
using ConstructionBase

include("errors.jl")
include("utils.jl")

include("interfaces/dirac_tensors.jl")
include("interfaces/gamma_matrices.jl")

include("interfaces/lorentz_vectors/types.jl")
include("interfaces/lorentz_vectors/registry.jl")
include("interfaces/lorentz_vectors/arithmetic.jl")
include("interfaces/lorentz_vectors/dirac_interaction.jl")
include("interfaces/lorentz_vectors/fields.jl")
include("interfaces/lorentz_vectors/utility.jl")

include("interfaces/four_momentum.jl")
include("interfaces/model.jl")

include("interfaces/particle.jl")
include("interfaces/particles/direction.jl")
include("interfaces/particles/spin_pol.jl")

include("interfaces/phase_space.jl")
include("interfaces/particle_stateful.jl")
include("interfaces/process.jl")
include("interfaces/phase_space_point.jl")

include("interfaces/phase_space_layout.jl")

include("interfaces/coordinate_transformation.jl")

include("implementations/phase_space_layout/build_momenta.jl")

include("implementations/process/momenta.jl")
include("implementations/process/particles.jl")
include("implementations/process/spin_pols.jl")
include("implementations/process/spin_pol_iterator.jl")

include("implementations/cross_section/diff_probability.jl")
include("implementations/cross_section/diff_cross_section.jl")
include("implementations/cross_section/total_probability.jl")
include("implementations/cross_section/total_cross_section.jl")

end #QEDbase

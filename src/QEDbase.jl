module QEDbase

using SimpleTraits
using ArgCheck
using ConstructionBase

import Base: *
import StaticArrays: similar_type

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

export AbstractLorentzVector, SLorentzVector, MLorentzVector, dot
export AbstractFourMomentum, SFourMomentum, MFourMomentum
export isonshell, assert_onshell

export BiSpinor, AdjointBiSpinor, DiracMatrix, mul
export AbstractDiracVector, AbstractDiracMatrix

export gamma, GAMMA, AbstractGammaRepresentation, DiracGammaRepresentation, slashed

export BASE_PARTICLE_SPINOR, BASE_ANTIPARTICLE_SPINOR
export IncomingFermionSpinor,
    OutgoingFermionSpinor, IncomingAntiFermionSpinor, OutgoingAntiFermionSpinor
export SpinorU, SpinorUbar, SpinorV, SpinorVbar
export @valid_spinor_input

# particle interface
export AbstractParticle
export is_fermion, is_boson, is_particle, is_anti_particle
export base_state
export mass, charge

# particle types
export AbstractParticleType
export FermionLike, Fermion, AntiFermion, MajoranaFermion
export BosonLike, Boson, AntiBoson, MajoranaBoson
export Electron, Positron, Photon
export ParticleDirection, Incoming, Outgoing
export is_incoming, is_outgoing
export propagator

# polarizations and spins
export AbstractSpinOrPolarization, AbstractPolarization, AbstractSpin
export AbstractDefinitePolarization, AbstractIndefinitePolarization
export PolarizationX, PolX, PolarizationY, PolY, AllPolarization, AllPol
export AbstractDefiniteSpin, AbstractIndefiniteSpin
export SpinUp, SpinDown, AllSpin
export multiplicity

using StaticArrays
using LinearAlgebra
using DocStringExtensions

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

# Abstract setup interface
export AbstractComputationSetup, InvalidInputError, compute
export AbstractProcessSetup, scattering_process, physical_model

include("interfaces/phase_space.jl")

include("interfaces/lorentz.jl")
include("dirac_tensors.jl")
include("lorentz_vector.jl")
include("gamma_matrices.jl")
include("four_momentum.jl") # maybe go to a kinematics module!!

include("interfaces/particle.jl")
include("particles/types.jl")
include("particles/direction.jl")
include("particles/spin_pol.jl")
include("particles/spinors.jl")
include("particles/states.jl")

include("interfaces/model.jl")

include("interfaces/process.jl")

include("interfaces/setup.jl")

end #QEDbase

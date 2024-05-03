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
export SFourMomentum, MFourMomentum, isonshell, assert_onshell

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

# polarizations and spins
export AbstractSpinOrPolarization, AbstractPolarization, AbstractSpin
export AbstractDefinitePolarization, AbstractIndefinitePolarization
export PolarizationX, PolX, PolarizationY, PolY, AllPolarization, AllPol
export AbstractDefiniteSpin, AbstractIndefiniteSpin
export SpinUp, SpinDown, AllSpin

using StaticArrays
using LinearAlgebra
using DocStringExtensions

include("dirac_tensors.jl")
include("lorentz_interface.jl")
include("lorentz_vector.jl")
include("gamma_matrices.jl")

include("four_momentum.jl") # maybe go to a kinematics module!!

include("interfaces/particle_interface.jl")
include("particles/particle_types.jl")
include("particles/particle_direction.jl")
include("particles/particle_spin_pol.jl")
include("particles/particle_spinors.jl")
include("particles/particle_states.jl")

end #QEDbase

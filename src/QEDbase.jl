"""
Main module of HEPbase.jl - a little library for manipulating Lorentz vectors and Dirac tensors.

# Exports
$(EXPORTS)
"""
module QEDbase

import Base:*
import StaticArrays: similar_type

export AbstractLorentzVector,LorentzVector, dot,magnitude
export FourMomentum, mass_square,mass,isonshell

export BiSpinor, AdjointBiSpinor, DiracMatrix, mul
export AbstractDiracVector, AbstractDiracMatrix

export gamma,GAMMA,AbstractGammaRepresentation, DiracGammaRepresentation, slashed



export BASE_PARTICLE_SPINOR,BASE_ANTIPARTICLE_SPINOR
export IncomingFermionSpinor,OutgoingFermionSpinor,IncomingAntiFermionSpinor,OutgoingAntiFermionSpinor
export SpinorU, SpinorUbar, SpinorV, SpinorVbar
export @valid_spinor_input

#export Coordinates

using StaticArrays
using LinearAlgebra
using DocStringExtensions



include("dirac_tensors.jl")
include("lorentz_vector.jl")
include("gamma_matrices.jl")

include("four_momentum.jl") # maybe go to a kinematics module!!
include("particle_spinors.jl")
#include("coordinates/coordinates.jl")


end #HEPbase

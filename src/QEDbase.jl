"""
Main module of HEPbase.jl - a little library for manipulating Lorentz vectors and Dirac tensors.

# Exports
$(EXPORTS)
"""
module QEDbase

using SimpleTraits
using ArgCheck
using ConstructionBase

import Base:*
import StaticArrays: similar_type




export minkowski_dot,mdot,register_LorentzVectorLike
export getT,getX, getY, getZ
export getMagnitude2, getMag2, getMagnitude,getMag
export getInvariantMass2, getMass2, getInvariantMass, getMass
export getE, getPx, getPy, getPz
export getBeta, getGamma
export getTransverseMomentum2, getPt2, getPerp2, getTransverseMomentum, getPt, getPerp
export getTransverseMass2, getMt2, getTransverseMass, getMt
export getRapidity
export getRho2,getRho
export getTheta,getCosTheta
export getPhi,getCosPhi,getSinPhi
export getPlus,getMinus

export setE!,setPx!,setPy!,setPz!
export setTheta!,setCosTheta!,setRho!
export setPlus!,setMinus!
export setTransversMomentum!,setPerp!,setPt!
export setTransverseMass!,setMt!
export setRapidity!

export AbstractLorentzVector,SLorentzVector,MLorentzVector, dot
export SFourMomentum,MFourMomentum,isonshell

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
include("lorentz_interface.jl")
include("lorentz_vector.jl")
include("gamma_matrices.jl")

include("four_momentum.jl") # maybe go to a kinematics module!!
include("particle_spinors.jl")
#include("coordinates/coordinates.jl")


end #HEPbase

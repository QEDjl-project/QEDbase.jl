
import Base.getindex

const SPINOR_VALIDITY_CHECK = Ref(true)

macro valid_spinor_input(ex)
    return quote
        SPINOR_VALIDITY_CHECK.x = false
        local val = $(esc(ex))
        SPINOR_VALIDITY_CHECK.x = true
        val
    end
end


const BASE_PARTICLE_SPINOR_UP = BiSpinor(1.0,0.0,0.0,0.0)
const BASE_PARTICLE_SPINOR_DOWN = BiSpinor(0.0,1.0,0.0,0.0)
const BASE_PARTICLE_SPINOR = [BASE_PARTICLE_SPINOR_UP,BASE_PARTICLE_SPINOR_DOWN]
const BASE_ANTIPARTICLE_SPINOR_UP = BiSpinor(0.0,0.0,1.0,0.0)
const BASE_ANTIPARTICLE_SPINOR_DOWN = BiSpinor(0.0,0.0,0.0,1.0)
const BASE_ANTIPARTICLE_SPINOR = [BASE_ANTIPARTICLE_SPINOR_UP,BASE_ANTIPARTICLE_SPINOR_DOWN]



mutable struct SpinorConstructionError <: Exception
        var::String
    end

Base.showerror(io::IO, e::SpinorConstructionError) = print(io, "SpinorConstructionError: ",e.var)

@inline function _check_spinor_input(mom::FourMomentum,mass::Float64)
    if SPINOR_VALIDITY_CHECK[] && !isonshell(mom,mass)
        throw(SpinorConstructionError("P^2 = $(mass_square(mom)) needs to be equal to mass^2=$(mass^2)"))
    end
end




abstract type AbstractParticleSpinor end

#
# fermion spinors
#

function _build_particle_booster(mom::FourMomentum,mass::Float64)
    _check_spinor_input(mom,mass)
    return (slashed(mom) + mass*one(DiracMatrix))/(sqrt(abs(mom.t)+mass))
end


struct IncomingFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

IncomingFermionSpinor(mom::FourMomentum,mass::Float64) = IncomingFermionSpinor(_build_particle_booster(mom,mass))

function (SP::IncomingFermionSpinor)(spin::Int64)
    return SP.booster*BASE_PARTICLE_SPINOR[spin]
end

const SpinorU = IncomingFermionSpinor


struct OutgoingFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

OutgoingFermionSpinor(mom::FourMomentum,mass::Float64) = OutgoingFermionSpinor(_build_particle_booster(mom,mass))

function (SP::OutgoingFermionSpinor)(spin::Int64)
    return AdjointBiSpinor(SP.booster*BASE_PARTICLE_SPINOR[spin])*GAMMA[1]
end

const SpinorUbar = OutgoingFermionSpinor


#
# Anti fermion spinors
#

function _build_antiparticle_booster(mom::FourMomentum,mass::Float64)
    _check_spinor_input(mom,mass)
    return (mass*one(DiracMatrix) - slashed(mom))/(sqrt(abs(mom.t)+mass))
end

struct OutgoingAntiFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

OutgoingAntiFermionSpinor(mom::FourMomentum,mass::Float64) = OutgoingAntiFermionSpinor(_build_antiparticle_booster(mom,mass))

function (SP::OutgoingAntiFermionSpinor)(spin::Int64)
    return SP.booster*BASE_ANTIPARTICLE_SPINOR[spin]
end

const SpinorV = OutgoingAntiFermionSpinor


struct IncomingAntiFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

IncomingAntiFermionSpinor(mom::FourMomentum,mass::Float64) = IncomingAntiFermionSpinor(_build_antiparticle_booster(mom,mass))

function (SP::IncomingAntiFermionSpinor)(spin::Int64)
    return AdjointBiSpinor(SP.booster*BASE_ANTIPARTICLE_SPINOR[spin])*GAMMA[1]
end

const SpinorVbar = IncomingAntiFermionSpinor



getindex(SP::T,idx) where {T<:AbstractParticleSpinor} = idx in (1,2) ? SP(idx) : throw(BoundsError())

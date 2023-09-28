
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

const BASE_PARTICLE_SPINOR_UP = BiSpinor(1.0, 0.0, 0.0, 0.0)
const BASE_PARTICLE_SPINOR_DOWN = BiSpinor(0.0, 1.0, 0.0, 0.0)
const BASE_PARTICLE_SPINOR = [BASE_PARTICLE_SPINOR_UP, BASE_PARTICLE_SPINOR_DOWN]
const BASE_ANTIPARTICLE_SPINOR_UP = BiSpinor(0.0, 0.0, 1.0, 0.0)
const BASE_ANTIPARTICLE_SPINOR_DOWN = BiSpinor(0.0, 0.0, 0.0, 1.0)
const BASE_ANTIPARTICLE_SPINOR = [
    BASE_ANTIPARTICLE_SPINOR_UP, BASE_ANTIPARTICLE_SPINOR_DOWN
]

mutable struct SpinorConstructionError <: Exception
    var::String
end

function Base.showerror(io::IO, e::SpinorConstructionError)
    return print(io, "SpinorConstructionError: ", e.var)
end

@inline function _check_spinor_input(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    if SPINOR_VALIDITY_CHECK[] && !isonshell(mom, mass)
        throw(
            SpinorConstructionError(
                "P^2 = $(getMass2(mom)) needs to be equal to mass^2=$(mass^2)"
            ),
        )
    end
end

abstract type AbstractParticleSpinor end

#
# fermion spinors
#

function _build_particle_booster(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    _check_spinor_input(mom, mass)
    return (slashed(mom) + mass * one(DiracMatrix)) / (sqrt(abs(mom.t) + mass))
end

struct IncomingFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

function IncomingFermionSpinor(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    return IncomingFermionSpinor(_build_particle_booster(mom, mass))
end

function (SP::IncomingFermionSpinor)(spin::Int64)
    return SP.booster * BASE_PARTICLE_SPINOR[spin]
end

const SpinorU = IncomingFermionSpinor

struct OutgoingFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

function OutgoingFermionSpinor(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    return OutgoingFermionSpinor(_build_particle_booster(mom, mass))
end

function (SP::OutgoingFermionSpinor)(spin::Int64)
    return AdjointBiSpinor(SP.booster * BASE_PARTICLE_SPINOR[spin]) * GAMMA[1]
end

const SpinorUbar = OutgoingFermionSpinor

#
# Anti fermion spinors
#

function _build_antiparticle_booster(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    _check_spinor_input(mom, mass)
    return (mass * one(DiracMatrix) - slashed(mom)) / (sqrt(abs(mom.t) + mass))
end

struct OutgoingAntiFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

function OutgoingAntiFermionSpinor(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    return OutgoingAntiFermionSpinor(_build_antiparticle_booster(mom, mass))
end

function (SP::OutgoingAntiFermionSpinor)(spin::Int64)
    return SP.booster * BASE_ANTIPARTICLE_SPINOR[spin]
end

const SpinorV = OutgoingAntiFermionSpinor

struct IncomingAntiFermionSpinor <: AbstractParticleSpinor
    booster::DiracMatrix
end

function IncomingAntiFermionSpinor(
    mom::T, mass::Float64
) where {T<:AbstractLorentzVector{TE}} where {TE<:Real}
    return IncomingAntiFermionSpinor(_build_antiparticle_booster(mom, mass))
end

function (SP::IncomingAntiFermionSpinor)(spin::Int64)
    return AdjointBiSpinor(SP.booster * BASE_ANTIPARTICLE_SPINOR[spin]) * GAMMA[1]
end

const SpinorVbar = IncomingAntiFermionSpinor

function getindex(SP::T, idx) where {T<:AbstractParticleSpinor}
    return idx in (1, 2) ? SP(idx) : throw(BoundsError())
end

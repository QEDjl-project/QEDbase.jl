###############
# The particle types 
#
# In this file, we define the types of particles, their states and directions, and
# implement the abstact particle interface accordingly. 
###############

using StaticArrays

"""
    AbstractParticleType <: AbstractParticle

This is the abstract base type for every species of particles. All functionalities defined on subtypes of `AbstractParticleType` should be static, i.e. known at compile time. 
For adding runtime information, e.g. four-momenta or particle states, to a particle, consider implementing a concrete subtype of `AbstractParticle` instead, which may have a type parameter `P<:AbstractParticleType`. See the concrete type `Particle{P,ST,MT}`

Concrete built-in subtypes of `AbstractParticleType` are 

```julia
    Electron
    Positron
    Photon
```

"""
abstract type AbstractParticleType <: AbstractParticle end

"""
Abstract base types for particle species that act like fermions in the sense of particle statistics. 
    
!!! note "particle interface"
    Every concrete subtype of [`FermionLike`](@ref) has `is_fermion(::FermionLike) = true`.
"""
abstract type FermionLike <: AbstractParticleType end

Base.@pure is_fermion(::FermionLike) = true

"""
Abstract base type for fermions as distinct from anti-fermions. 
    
!!! note "particle interface"
    All subtypes of `Fermion` have
    ```julia 
    is_fermion(::Fermion) = true
    is_particle(::Fermion) = true
    is_anti_particle(::Fermion) = false
    ```

"""
abstract type Fermion <: FermionLike end

is_particle(::Fermion) = true

is_anti_particle(::Fermion) = false

"""
Abstract base type for anti-fermions as distinct from its particle counterpart `Fermion`.

!!! note "particle interface"
    All subtypes of `AntiFermion` have 
    ```julia 
    is_fermion(::AntiFermion) = true
    is_particle(::AntiFermion) = false
    is_anti_particle(::AntiFermion) = true
    ```
    
"""
abstract type AntiFermion <: FermionLike end

is_particle(::AntiFermion) = false

is_anti_particle(::AntiFermion) = true

"""
Abstract base type for majorana-fermions, i.e. fermions which are their own anti-particles.

!!! note "particle interface"
    All subtypes of `MajoranaFermion` have 
    ```julia 
    is_fermion(::MajoranaFermion) = true
    is_particle(::MajoranaFermion) = true
    is_anti_particle(::MajoranaFermion) = true
    ```
    
"""
abstract type MajoranaFermion <: FermionLike end

is_particle(::MajoranaFermion) = true

is_anti_particle(::MajoranaFermion) = true

"""
Concrete type for *electrons* as a particle species. Mostly used for dispatch. 

!!! note "particle interface"
    Besides being a subtype of `Fermion`, objects of type `Electron` have

    ```julia
    mass(::Electron) = 1.0
    charge(::Electron) = -1.0
    ```
"""
struct Electron <: Fermion end
mass(::Electron) = 1.0
charge(::Electron) = -1.0

"""
Concrete type for *positrons* as a particle species. Mostly used for dispatch. 

!!! note "particle interface"
    Besides being a subtype of `AntiFermion`, objects of type `Positron` have

    ```julia
    mass(::Positron) = 1.0
    charge(::Positron) = 1.0
    ```
    
"""
struct Positron <: AntiFermion end
mass(::Positron) = 1.0
charge(::Positron) = 1.0

"""
Abstract base types for particle species that act like bosons in the sense of particle statistics. 
    
!!! note "particle interface"
    Every concrete subtype of [`BosonLike`](@ref) has `is_boson(::BosonLike) = true`.
"""
abstract type BosonLike <: AbstractParticleType end

is_boson(::BosonLike) = true

"""
Abstract base type for bosons as distinct from its anti-particle counterpart `AntiBoson`. 
    
!!! note "particle interface"
    All subtypes of `Boson` have
    ```julia 
    is_boson(::Boson) = true
    is_particle(::Boson) = true
    is_anti_particle(::Boson) = false
    ```

"""
abstract type Boson <: BosonLike end
is_particle(::Boson) = true
is_anti_particle(::Boson) = false

"""
Abstract base type for anti-bosons as distinct from its particle counterpart `Bosons`. 
    
!!! note "particle interface"
    All subtypes of `AntiBoson` have
    ```julia 
    is_boson(::AntiBoson) = true
    is_particle(::AntiBoson) = false
    is_anti_particle(::AntiBoson) = true
    ```

"""
abstract type AntiBoson <: BosonLike end
is_particle(::AntiBoson) = false
is_anti_particle(::AntiBoson) = true

"""
Abstract base type for majorana-bosons, i.e. bosons which are their own anti-particles.

!!! note "particle interface"
    All subtypes of `MajoranaBoson` have 
    ```julia 
    is_boson(::MajoranaBoson) = true
    is_particle(::MajoranaBoson) = true
    is_anti_particle(::MajoranaBoson) = true
    ```
    
"""
abstract type MajoranaBoson <: BosonLike end
is_particle(::MajoranaBoson) = true
is_anti_particle(::MajoranaBoson) = true

"""
Concrete type for the *photons* as a particle species. Mostly used for dispatch. 

!!! note "particle interface"
    Besides being a subtype of `MajoranaBoson`, `Photon` has

    ```julia
    mass(::Photon) = 0.0
    charge(::Photon) = 0.0
    ```
    
"""
struct Photon <: MajoranaBoson end
mass(::Photon) = 0.0
charge(::Photon) = 0.0

"""
Abstract base type for the directions of particles in the context of processes, i.e. either they are *incoming* or *outgoing*. Subtypes of this are mostly used for dispatch.
"""
abstract type ParticleDirection end

"""

    Incoming <: ParticleDirection

Concrete implementation of a `ParticleDirection` to indicate that a particle is *incoming* in the context of a given process. Mostly used for dispatch.

!!! note "ParticleDirection Interface"
    Besides being a subtype of `ParticleDirection`, `Incoming` has

    ```julia
    is_incoming(::Incoming) = true
    is_outgoing(::Incoming) = false
    ```
"""
struct Incoming <: ParticleDirection end
Base.@pure is_incoming(::Incoming) = true
Base.@pure is_outgoing(::Incoming) = false

"""

    Outgoing <: ParticleDirection

Concrete implementation of a `ParticleDirection` to indicate that a particle is *outgoing* in the context of a given process. Mostly used for dispatch.

!!! note "ParticleDirection Interface"
    Besides being a subtype of `ParticleDirection`, `Outgoing` has

    ```julia
    is_incoming(::Outgoing) = false
    is_outgoing(::Outgoing) = true
    ```
"""
struct Outgoing <: ParticleDirection end
Base.@pure is_incoming(::Outgoing) = false
Base.@pure is_outgoing(::Outgoing) = true

####
# spins and polarizations
####

"""
Abstract base type for the spin or polarization of particles. 
"""
abstract type AbstractSpinOrPolarization end

"""
Abstract base type for the spin of [`FermionLike`](@ref) particles.
"""
abstract type AbstractSpin <: AbstractSpinOrPolarization end

"""
Abstract base type for definite spins of [`FermionLike`](@ref) particles.

Concrete types are [`SpinUp`](@ref) and [`SpinDown`](@ref).
"""
abstract type AbstractDefiniteSpin <: AbstractSpin end

"""
Abstract base type for indefinite spins of [`FermionLike`](@ref) particles.

One concrete type is [`SpinAll`](@ref).
"""
abstract type AbstractIndefiniteSpin <: AbstractSpin end

"""
Concrete type indicating that a [`FermionLike`](@ref) has spin-up.
"""
struct SpinUp <: AbstractDefiniteSpin end

"""
Concrete type indicating that a [`FermionLike`](@ref) has spin-down.
"""
struct SpinDown <: AbstractDefiniteSpin end

"""
Concrete type indicating that a [`FermionLike`](@ref) has an indefinite spin and should average or sum over all spins, depending on direction.
"""
struct SpinAll <: AbstractIndefiniteSpin end

"""
    $(TYPEDSIGNATURES)

Utility function, which converts subtypes of [`AbstractDefiniteSpin`](@ref) into an integer representation, e.g. an index:

- `SpinUp`   ``\\rightarrow 1 ``
- `SpinDown` ``\\rightarrow 2``

This is useful in the implementation of some of [`base_state`](@ref)'s overloads.
"""
function _spin_index(::AbstractDefiniteSpin) end
_spin_index(::SpinUp) = 1
_spin_index(::SpinDown) = 2

"""
Abstract base type for the polarization of [`BosonLike`](@ref) particles.
"""
abstract type AbstractPolarization <: AbstractSpinOrPolarization end

"""
Abstract base type for definite polarizations of [`BosonLike`](@ref) particles.

Concrete types are [`PolarizationX`](@ref) and [`PolarizationY`](@ref).
"""
abstract type AbstractDefinitePolarization <: AbstractPolarization end

"""
Abstract base type for indefinite polarizations of [`BosonLike`](@ref) particles.

One concrete type is [`AllPolarization`](@ref).
"""
abstract type AbstractIndefinitePolarization <: AbstractPolarization end

"""
Concrete type indicating that a [`BosonLike`](@ref) has an indefinite polarization and should average or sum over all polarizations, depending on direction.

!!! info
    There is a built-in alias for `AllPolarization`:
```jldoctest
julia> using QEDbase

julia> AllPolarization === AllPol
true
```
"""
struct AllPolarization <: AbstractIndefinitePolarization end
const AllPol = AllPolarization

"""
Concrete type which indicates, that a [`BosonLike`](@ref) has polarization in ``x``-direction.

!!! note "Coordinate axes"

    The notion of axes, e.g. ``x``- and ``y``-direction is just to distinguish two orthogonal polarization directions.
    However, if the three-momentum of the [`BosonLike`](@ref) is aligned to the ``z``-axis of a coordinate system, the polarization axes define the ``x``- or ``y``-axis, respectively.

!!! info 
    There is a built-in alias for `PolarizationX`:
```jldoctest
julia> using QEDbase

julia> PolX === PolarizationX
true
```
"""
struct PolarizationX <: AbstractDefinitePolarization end
const PolX = PolarizationX

"""
Concrete type which indicates, that a [`BosonLike`](@ref) has polarization in ``x``-direction.

!!! note "Coordinate axes"

    The notion of axes, e.g. ``x``- and ``y``-direction is just to distinguish two orthogonal polarization directions.
    However, if the three-momentum of the [`BosonLike`](@ref) is aligned to the ``z``-axis of a coordinate system, the polarization axes define the ``x``- or ``y``-axis, respectively.

!!! info 
    There is a built-in alias for `PolarizationY`:
```jldoctest
julia> using QEDbase

julia> PolY === PolarizationY
true
```
"""
struct PolarizationY <: AbstractDefinitePolarization end
const PolY = PolarizationY

####
# states
####

function _booster_fermion(mom::QEDbase.AbstractFourMomentum, mass::Real)
    return (slashed(mom) + mass * one(DiracMatrix)) / (sqrt(abs(getT(mom)) + mass))
end

function _booster_antifermion(mom::QEDbase.AbstractFourMomentum, mass::Real)
    return (mass * one(DiracMatrix) - slashed(mom)) / (sqrt(abs(getT(mom)) + mass))
end

"""
```julia 
    base_state(
        particle::AbstractParticleType,             
        direction::ParticleDirection,               
        momentum::QEDbase.AbstractFourMomentum,     
        [spin_or_pol::AbstractSpinOrPolarization]   
    )
```

Return the base state of a directed on-shell particle with a given four-momentum. For internal usage only.


# Input

- `particle` -- the type of the particle, i.e. `Electron`, `Positron`, or `Photon`
- `direction` -- the direction of the particle, i.e. `Incoming` or `Outgoing`
- `momentum` -- the four-momentum of the particle
- `[spin_or_pol]` -- if given, the spin or polarization of the particle, i.e. `SpinUp`/`SpinDown` or `PolX`/`PolY`

# Output
The output type of `base_state` depends on wether the spin or polarization of the particle passed in is specified or not.

If `spin_or_pol` is passed, the output of `base_state` is

```julia
base_state(::Fermion,     ::Incoming, mom, spin_or_pol) -> BiSpinor
base_state(::AntiFermion, ::Incoming, mom, spin_or_pol) -> AdjointBiSpinor
base_state(::Fermion,     ::Outgoing, mom, spin_or_pol) -> AdjointBiSpinor
base_state(::AntiFermion, ::Outgoing, mom, spin_or_pol) -> BiSpinor
base_state(::Photon,      ::Incoming, mom, spin_or_pol) -> SLorentzVector{ComplexF64}
base_state(::Photon,      ::Outgoing, mom, spin_or_pol) -> SLorentzVector{ComplexF64}
```

If `spin_or_pol` is not passed to `base_state`, the output is a `StaticVector` with both spin/polarization alignments:

```julia
base_state(::Fermion,     ::Incoming, mom) -> SVector{2,BiSpinor}
base_state(::AntiFermion, ::Incoming, mom) -> SVector{2,AdjointBiSpinor}
base_state(::Fermion,     ::Outgoing, mom) -> SVector{2,AdjointBiSpinor}
base_state(::AntiFermion, ::Outgoing, mom) -> SVector{2,BiSpinor}
base_state(::Photon,      ::Incoming, mom) -> SVector{2,SLorentzVector{ComplexF64}}
base_state(::Photon,      ::Outgoing, mom) -> SVector{2,SLorentzVector{ComplexF64}}
```

# Example

```julia

using QEDbase
using QEDprocesses

mass = 1.0                              # set electron mass to 1.0
px,py,pz = rand(3)                      # generate random spatial components
E = sqrt(px^2 + py^2 + pz^2 + mass^2)   # compute energy, i.e. the electron is on-shell
mom = SFourMomentum(E,px,py,pz)         # initialize the four-momentum of the electron

# compute the state of an incoming electron with spin = SpinUp
# note: base_state is not exported!
electron_state = QEDProcesses.base_state(Electron(),Incoming(),mom, SpinUp)
        
```

!!! note "Conventions"

    For an incoming fermion with momentum ``p``, we use the explicit formula:

    ```math
    u_\\sigma(p) = \\frac{\\gamma^\\mu p_\\mu + m}{\\sqrt{\\vert p_0\\vert  + m}} \\eta_\\sigma,
    ```

    where the elementary base spinors are given as

    ```math
    \\eta_1 = (1, 0, 0, 0)^T\\\\
    \\eta_2 = (0, 1, 0, 0)^T
    ```

    For an outgoing anti-fermion with momentum ``p``, we use the explicit formula:

    ```math
    v_\\sigma(p) = \\frac{-\\gamma^\\mu p_\\mu + m}{\\sqrt{\\vert p_0\\vert  + m}} \\chi_\\sigma,
    ```

    where the elementary base spinors are given as

    ```math
    \\chi_1 = (0, 0, 1, 0)^T\\\\
    \\chi_2 = (0, 0, 0, 1)^T
    ```

    For outgoing fermions and incoming anti-fermion with momentum ``p``, the base state is given as the Dirac-adjoint of the respective incoming fermion- or outgoing anti-fermion state:

    ```math
    \\overline{u}_\\sigma(p) = u_\\sigma^\\dagger \\gamma^0\\\\
    \\overline{v}_\\sigma(p) = v_\\sigma^\\dagger \\gamma^0
    ```

    where ``v_\\sigma`` is the base state of the respective outgoing anti-fermion.

    For a photon with four-momentum ``k^\\mu = \\omega (1, \\cos\\phi \\sin\\theta, \\sin\\phi \\sin\\theta, \\cos\\theta)``, the two polarization vectors are given as
    
    ```math
    \\begin{align*}
    \\epsilon^\\mu_1 &= (0, \\cos\\theta \\cos\\phi, \\cos\\theta \\sin\\phi, -\\sin\\theta),\\\\
    \\epsilon^\\mu_2 &= (0, -\\sin\\phi, \\cos\\phi, 0).
    \\end{align*}
    ```

!!! warning
    In the current implementation there are **no checks** built-in, which verify the passed arguments whether they describe on-shell particles, i.e. `p*p≈mass^2`. Using `base_state` with off-shell particles will cause unpredictable behavior.
"""
function base_state end

function base_state(
    particle::Fermion, ::Incoming, mom::QEDbase.AbstractFourMomentum, spin::AbstractSpin
)
    booster = _booster_fermion(mom, mass(particle))
    return BiSpinor(booster[:, _spin_index(spin)])
end

function base_state(particle::Fermion, ::Incoming, mom::QEDbase.AbstractFourMomentum)
    booster = _booster_fermion(mom, mass(particle))
    return SVector(BiSpinor(booster[:, 1]), BiSpinor(booster[:, 2]))
end

function base_state(
    particle::AntiFermion, ::Incoming, mom::QEDbase.AbstractFourMomentum, spin::AbstractSpin
)
    booster = _booster_antifermion(mom, mass(particle))
    return AdjointBiSpinor(BiSpinor(booster[:, _spin_index(spin) + 2])) * GAMMA[1]
end

function base_state(particle::AntiFermion, ::Incoming, mom::QEDbase.AbstractFourMomentum)
    booster = _booster_antifermion(mom, mass(particle))
    return SVector(
        AdjointBiSpinor(BiSpinor(booster[:, 3])) * GAMMA[1],
        AdjointBiSpinor(BiSpinor(booster[:, 4])) * GAMMA[1],
    )
end

function base_state(
    particle::Fermion, ::Outgoing, mom::QEDbase.AbstractFourMomentum, spin::AbstractSpin
)
    booster = _booster_fermion(mom, mass(particle))
    return AdjointBiSpinor(BiSpinor(booster[:, _spin_index(spin)])) * GAMMA[1]
end

function base_state(particle::Fermion, ::Outgoing, mom::QEDbase.AbstractFourMomentum)
    booster = _booster_fermion(mom, mass(particle))
    return SVector(
        AdjointBiSpinor(BiSpinor(booster[:, 1])) * GAMMA[1],
        AdjointBiSpinor(BiSpinor(booster[:, 2])) * GAMMA[1],
    )
end

function base_state(
    particle::AntiFermion, ::Outgoing, mom::QEDbase.AbstractFourMomentum, spin::AbstractSpin
)
    booster = _booster_antifermion(mom, mass(particle))
    return BiSpinor(booster[:, _spin_index(spin) + 2])
end

function base_state(particle::AntiFermion, ::Outgoing, mom::QEDbase.AbstractFourMomentum)
    booster = _booster_antifermion(mom, mass(particle))
    return SVector(BiSpinor(booster[:, 3]), BiSpinor(booster[:, 4]))
end

function _photon_state(mom::QEDbase.AbstractFourMomentum)
    cth = getCosTheta(mom)
    sth = sqrt(1 - cth^2)
    sin_phi = getSinPhi(mom)
    cos_phi = sqrt(1 - sin_phi^2)
    return SVector(
        SLorentzVector{Float64}(0.0, cth * cos_phi, cth * sin_phi, -sth),
        SLorentzVector{Float64}(0.0, -sin_phi, cos_phi, 0.0),
    )
end

function _photon_state(pol::PolarizationX, mom::QEDbase.AbstractFourMomentum)
    cth = getCosTheta(mom)
    sth = sqrt(1 - cth^2)
    sin_phi = getSinPhi(mom)
    cos_phi = sqrt(1 - sin_phi^2)
    return SLorentzVector{Float64}(0.0, cth * cos_phi, cth * sin_phi, -sth)
end

function _photon_state(pol::PolarizationY, mom::QEDbase.AbstractFourMomentum)
    sin_phi = getSinPhi(mom)
    cos_phi = sqrt(1 - sin_phi^2)
    return SLorentzVector{Float64}(0.0, -sin_phi, cos_phi, 0.0)
end

@inline function base_state(
    particle::Photon, ::ParticleDirection, mom::QEDbase.AbstractFourMomentum
)
    return _photon_state(mom)
end

@inline function base_state(
    particle::Photon,
    ::ParticleDirection,
    mom::QEDbase.AbstractFourMomentum,
    pol::AbstractPolarization,
)
    return _photon_state(pol, mom)
end

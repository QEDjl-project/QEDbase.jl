###############
# The particle types 
#
# In this file, we define the types of particles, their states and directions, and
# implement the abstact particle interface accordingly. 
###############

"""
    AbstractParticleSpinor

TBW
"""
abstract type AbstractParticleSpinor end

"""
    AbstractParticleType <: AbstractParticle

This is the abstract base type for every species of particles. All functionalities defined on subtypes of `AbstractParticleType` should be static, i.e. known at compile time. 
For adding runtime information, e.g. four-momenta or particle states, to a particle, consider implementing a concrete subtype of [`AbstractParticle`](@ref) instead, which may have a type parameter `P<:AbstractParticleType`.

Concrete built-in subtypes of `AbstractParticleType` are [`Electron`](@ref), [`Positron`](@ref) and [`Photon`](@ref).
"""
abstract type AbstractParticleType <: AbstractParticle end

"""
Abstract base types for particle species that act like fermions in the sense of particle statistics.

!!! note "particle interface"
    Every concrete subtype of [`FermionLike`](@ref) has `is_fermion(::FermionLike) = true`.
"""
abstract type FermionLike <: AbstractParticleType end

is_fermion(::FermionLike) = true

"""
Abstract base type for fermions as distinct from [`AntiFermion`](@ref)s.
    
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

```jldoctest
julia> using QEDbase

julia> Electron()
electron
```

!!! note "particle interface"
    Besides being a subtype of [`Fermion`](@ref), objects of type `Electron` have

    ```julia
    mass(::Electron) = 1.0
    charge(::Electron) = -1.0
    ```
"""
struct Electron <: Fermion end
mass(::Electron) = 1.0
charge(::Electron) = -1.0
Base.show(io::IO, ::Electron) = print(io, "electron")

"""
Concrete type for *positrons* as a particle species. Mostly used for dispatch. 

```jldoctest
julia> using QEDbase

julia> Positron()
positron
```

!!! note "particle interface"
    Besides being a subtype of [`AntiFermion`](@ref), objects of type `Positron` have

    ```julia
    mass(::Positron) = 1.0
    charge(::Positron) = 1.0
    ```
    
"""
struct Positron <: AntiFermion end
mass(::Positron) = 1.0
charge(::Positron) = 1.0
Base.show(io::IO, ::Positron) = print(io, "positron")

"""
Abstract base types for particle species that act like bosons in the sense of particle statistics. 
    
!!! note "particle interface"
    Every concrete subtype of `BosonLike` has `is_boson(::BosonLike) = true`.
"""
abstract type BosonLike <: AbstractParticleType end

is_boson(::BosonLike) = true

"""
Abstract base type for bosons as distinct from its anti-particle counterpart [`AntiBoson`](@ref).
    
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
Abstract base type for anti-bosons as distinct from its particle counterpart [`Boson`](@ref).
    
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

```jldoctest
julia> using QEDbase

julia> Photon()
photon
```

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
Base.show(io::IO, ::Photon) = print(io, "photon")

"""
    propagator(particle::AbstractParticleType, mom::QEDbase.AbstractFourMomentum, [mass::Real])

Return the propagator of a particle for a given four-momentum. If `mass` is passed, the respective propagator for massive particles is used, if not, it is assumed the particle passed in is massless.

!!! note "Convention"
    
    There are two types of implementations for propagators given in `QEDProcesses`: 
    For a `BosonLike` particle with four-momentum ``k`` and mass ``m``, the propagator is given as 

    ```math
    D(k) = \\frac{1}{k^2 - m^2}.
    ```

    For a `FermionLike` particle with four-momentum ``p`` and mass ``m``, the propagator is given as

    ```math
    S(p) = \\frac{\\gamma^\\mu p_\\mu + mass}{p^2 - m^2}.
    ```

!!! warning
    
    This function does not throw when the given particle is off-shell. If an off-shell particle is passed, the function `propagator` returns `Inf`.

"""
function propagator end

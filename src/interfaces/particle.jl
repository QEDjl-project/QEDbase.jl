###############
# The particle interface
#
# In this file, we define the interface for working with particles in a general
# sense. 
###############

"""
Abstract base type for every type which might be considered a *particle* in the context of `QED.jl`. For every (concrete) subtype of `AbstractParticle`, there are two kinds of interface functions implemented: static functions and property functions. 
The static functions provide information on what kind of particle it is (defaults are written in square brackets)

```julia
    is_fermion(::AbstractParticle)::Bool [= false]
    is_boson(::AbstractParticle)::Bool [= false]
    is_particle(::AbstractParticle)::Bool [= true]
    is_anti_particle(::AbstractParticle)::Bool [= false]
``` 
If the output of those functions differ from the defaults for a subtype of `AbstractParticle`, these functions need to be overwritten.
The second type of functions define a hard interface for `AbstractParticle`:

```julia
    mass(::AbstractParticle)::Real
    charge(::AbstractParticle)::Real
```
These functions must be implemented in order to have the subtype of `AbstractParticle` work with the functionalities of `QEDprocesses.jl`.
"""
abstract type AbstractParticle end
Base.broadcastable(part::AbstractParticle) = Ref(part)

"""
    AbstractParticleType <: AbstractParticle

This is the abstract base type for every species of particles. All functionalities defined on subtypes of `AbstractParticleType` should be static, i.e. known at compile time. 
For adding runtime information, e.g. four-momenta or particle states, to a particle, consider implementing a concrete subtype of [`AbstractParticle`](@ref) instead, which may have a type parameter `P<:AbstractParticleType`.

Concrete built-in subtypes of `AbstractParticleType` are available in `QEDcore.jl` and should always be singletons..
"""
abstract type AbstractParticleType <: AbstractParticle end

"""
    $(TYPEDSIGNATURES)

Interface function for particles. Return `true` if the passed subtype of [`AbstractParticle`](@ref) can be considered a *fermion* in the sense of particle statistics, and `false` otherwise.
The default implementation of `is_fermion` for every subtype of [`AbstractParticle`](@ref) will always return `false`.
"""
is_fermion(::AbstractParticle) = false

"""
    $(TYPEDSIGNATURES)

Interface function for particles. Return `true` if the passed subtype of [`AbstractParticle`](@ref) can be considered a *boson* in the sense of particle statistics, and `false` otherwise.
The default implementation of `is_boson` for every subtype of [`AbstractParticle`](@ref) will always return `false`.
"""
is_boson(::AbstractParticle) = false

"""
    $(TYPEDSIGNATURES)
    
Interface function for particles. Return `true` if the passed subtype of [`AbstractParticle`](@ref) can be considered a *particle* as distinct from anti-particles, and `false` otherwise.
The default implementation of `is_particle` for every subtype of [`AbstractParticle`](@ref) will always return `true`.
"""
is_particle(::AbstractParticle) = true

"""
    $(TYPEDSIGNATURES)

Interface function for particles. Return true if the passed subtype of [`AbstractParticle`](@ref) can be considered an *anti particle* as distinct from their particle counterpart, and `false` otherwise.
The default implementation of `is_anti_particle` for every subtype of [`AbstractParticle`](@ref) will always return `false`.
"""
is_anti_particle(::AbstractParticle) = false

"""
    mass(particle::AbstractParticle)::Real

Interface function for particles. Return the rest mass of a particle (in units of the electron mass).

This needs to be implemented for each concrete subtype of [`AbstractParticle`](@ref).
"""
function mass end

"""
    charge(::AbstractParticle)::Real

Interface function for particles. Return the electric charge of a particle (in units of the elementary electric charge).

This needs to be implemented for each concrete subtype of [`AbstractParticle`](@ref).
"""
function charge end

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

- `particle` -- the type of the particle, e.g. `QEDcore.Electron`, `QEDcore.Positron`, or `QEDcore.Photon`.
- `direction` -- the direction of the particle, i.e. [`Incoming`](@ref) or [`Outgoing`](@ref).
- `momentum` -- the four-momentum of the particle
- `[spin_or_pol]` -- if given, the spin or polarization of the particle, e.g. [`SpinUp`](@ref)/[`SpinDown`](@ref) or [`PolarizationX`](@ref)/[`PolarizationY`](@ref).

# Output
The output type of `base_state` depends on wether the spin or polarization of the particle passed in is specified or not.

If `spin_or_pol` is passed, the output of `base_state` is

```julia
base_state(::Fermion,     ::Incoming, mom, spin_or_pol) # -> BiSpinor
base_state(::AntiFermion, ::Incoming, mom, spin_or_pol) # -> AdjointBiSpinor
base_state(::Fermion,     ::Outgoing, mom, spin_or_pol) # -> AdjointBiSpinor
base_state(::AntiFermion, ::Outgoing, mom, spin_or_pol) # -> BiSpinor
base_state(::Photon,      ::Incoming, mom, spin_or_pol) # -> SLorentzVector{ComplexF64}
base_state(::Photon,      ::Outgoing, mom, spin_or_pol) # -> SLorentzVector{ComplexF64}
```

If `spin_or_pol` is of type [`AllPolarization`](@ref) or [`AllSpin`](@ref), the output is an `SVector` with both spin/polarization alignments:

```julia
base_state(::Fermion,     ::Incoming, mom) # -> SVector{2,BiSpinor}
base_state(::AntiFermion, ::Incoming, mom) # -> SVector{2,AdjointBiSpinor}
base_state(::Fermion,     ::Outgoing, mom) # -> SVector{2,AdjointBiSpinor}
base_state(::AntiFermion, ::Outgoing, mom) # -> SVector{2,BiSpinor}
base_state(::Photon,      ::Incoming, mom) # -> SVector{2,SLorentzVector{ComplexF64}}
base_state(::Photon,      ::Outgoing, mom) # -> SVector{2,SLorentzVector{ComplexF64}}
```

# Example

```julia
using QEDbase

mass = 1.0                              # set electron mass to 1.0
px,py,pz = rand(3)                      # generate random spatial components
E = sqrt(px^2 + py^2 + pz^2 + mass^2)   # compute energy, i.e. the electron is on-shell
mom = SFourMomentum(E, px, py, pz)      # initialize the four-momentum of the electron

# compute the state of an incoming electron with spin = SpinUp
# note: base_state is not exported!
electron_state = base_state(QEDcore.Electron(), Incoming(), mom, SpinUp())
```

```jldoctest
julia> using QEDbase; using QEDcore

julia> mass = 1.0; px,py,pz = (0.1, 0.2, 0.3); E = sqrt(px^2 + py^2 + pz^2 + mass^2); mom = SFourMomentum(E, px, py, pz)
4-element SFourMomentum with indices SOneTo(4):
 1.0677078252031311
 0.1
 0.2
 0.3

julia> electron_state = base_state(Electron(), Incoming(), mom, SpinUp())
4-element BiSpinor with indices SOneTo(4):
   1.4379526505428235 + 0.0im
                  0.0 + 0.0im
 -0.20862995724285552 + 0.0im
 -0.06954331908095185 - 0.1390866381619037im

julia> electron_states = base_state(Electron(), Incoming(), mom, AllSpin())
2-element StaticArraysCore.SVector{2, BiSpinor} with indices SOneTo(2):
 [1.4379526505428235 + 0.0im, 0.0 + 0.0im, -0.20862995724285552 + 0.0im, -0.06954331908095185 - 0.1390866381619037im]
 [0.0 + 0.0im, 1.4379526505428235 + 0.0im, -0.06954331908095185 + 0.1390866381619037im, 0.20862995724285552 + 0.0im]
```

!!! note "Iterator convenience"
    The returned objects of `base_state` can be consistently wrapped in an `SVector` for iteration using [`_as_svec`](@ref).

    This way, a loop like the following becomes possible when `spin` may be definite or indefinite.
    ```julia
    for state in QEDbase._as_svec(base_state(Electron(), Incoming(), momentum, spin))
        # ...
    end
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

    For outgoing fermions and incoming anti-fermions with momentum ``p``, the base state is given as the Dirac-adjoint of the respective incoming fermion or outgoing anti-fermion state:

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

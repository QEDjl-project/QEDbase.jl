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
base_state(::Fermion,     ::Incoming, mom, spin_or_pol) # -> BiSpinor
base_state(::AntiFermion, ::Incoming, mom, spin_or_pol) # -> AdjointBiSpinor
base_state(::Fermion,     ::Outgoing, mom, spin_or_pol) # -> AdjointBiSpinor
base_state(::AntiFermion, ::Outgoing, mom, spin_or_pol) # -> BiSpinor
base_state(::Photon,      ::Incoming, mom, spin_or_pol) # -> SLorentzVector{ComplexF64}
base_state(::Photon,      ::Outgoing, mom, spin_or_pol) # -> SLorentzVector{ComplexF64}
```

If `spin_or_pol` is not passed to `base_state`, the output is a `StaticVector` with both spin/polarization alignments:

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
using QEDprocesses

mass = 1.0                              # set electron mass to 1.0
px,py,pz = rand(3)                      # generate random spatial components
E = sqrt(px^2 + py^2 + pz^2 + mass^2)   # compute energy, i.e. the electron is on-shell
mom = SFourMomentum(E, px, py, pz)      # initialize the four-momentum of the electron

# compute the state of an incoming electron with spin = SpinUp
# note: base_state is not exported!
electron_state = QEDProcesses.base_state(Electron(), Incoming(), mom, SpinUp)
        
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

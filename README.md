# QEDbase

[![Doc Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/stable)
[![Doc Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/dev)
[![Build Status](https://gitlab.hzdr.de/qedjl/QEDbase.jl/badges/main/pipeline.svg)](https://gitlab.hzdr.de/qedjl/QEDbase.jl/pipelines)
[![Coverage](https://gitlab.hzdr.de/qedjl/QEDbase.jl/badges/main/coverage.svg)](https://gitlab.hzdr.de/qedjl/QEDbase.jl/commits/main)
[![Coverage](https://codecov.io/gh/qedjl/QEDbase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/qedjl/QEDbase.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package is part of the `QuantumElectrodynamics.jl` library. For the description of the interoperability with other packages of `QuantumElectrodynamics.jl` see [docs](https://qedjl-project.github.io/QuantumElectrodynamics.jl/dev/).

## Interfaces

- **Lorentz vector:** enabling types to be used as Lorentz vector
- **Particle:** particles with a mass, a charge, and all that.
- **Computation model:** physical model, e.g. perturbative QED, to be used in
  calculations
- **Scattering process:** generic description of a scattering process to be used in
  calculations.
- **Differential probability:** common building blocks for the calculation of differential probabilities and
  cross-sections.
- **Phase spaces:** common functions to define phase spaces and work with phase space points.

## Installation

To install the current stable version of `QEDbase.jl` you may use the standard Julia package manager within the Julia REPL

```julia
julia> using Pkg

julia> Pkg.add("QEDbase")
```

or you use the Pkg prompt by hitting `]` within the Julia REPL and then type

```julia
pkg> add QEDbase
```

## Quickstart

Say we have a toymodel with two scalar particles `A` and `B`. Say we have an analytical
formula for the matrix element of the process $A(p_A)B(p_B) -> A(p_A')B(p_B')` given as

$$
M(p_A, p_B, p_A', p_B') = \frac{i}{(p_A + p_B)^2} + \frac{i}{(p_A-p_A')^2}.
$$

To implement this, we need to implement several interfaces

````Julia
using QEDbase # for interfaces
using QEDcore # for functionality

#particle interface

struct particle_A <: BosonLike end
struct particle_B <: BosonLike end

# model interface
struct MyToyModel <: AbstractModelDefinition end
QEDbase.interaction_type(::MyToyModel) = :mytoyinteraction

# process interface
struct ABtoAB <: AbstractProcessDefinition end
QEDbase.incoming_particles(::ABtoAB) = (particle_A(), particle_B())
QEDbase.outgoing_particles(::ABtoAB) = (particle_A(), particle_B())

# phase space definition
struct TrivialPhaseSpaceDef <: AbstractPhasespaceDefinition end

function QEDbase._incident_flux(in_psp::InPhaseSpacePoint{<:ABtoAB,<:MyToyModel})
    in_moms = momenta(in_psp,Incoming())
    return in_moms[1]*in_moms[2]
end

function QEDbase._averaging_norm(proc::ABtoAB)
    return 1.0
end

function QEDbase._matrix_element(psp::PhaseSpacePoint{<:ABtoAB,MyToyModel})
    in_moms = momenta(psp, Incoming())
    sum_in_moms = in_moms[1] + in_moms[2]
    out_moms = momenta(psp, Outgoing())
    diff_moms = in_moms[1] - out_moms[1]
    out = inv(sum_in_moms*sum_in_moms) + inv(diff_moms*diff_moms))
    return 1j*out
end

function QEDbase._is_in_phasespace(psp::PhaseSpacePoint{<:TestProcess,TestModel})
    in_moms = momenta(psp, Incoming())
    sum_in_moms = in_moms[1] + in_moms[2]
    out_moms = momenta(psp, Outgoing())
    sum_out_moms = out_moms[1] + out_moms[2]
    return isapprox(sum_in_moms,sum_out_moms)
end
``` pandoc -f odt -o mydoc.pdf mydoc.odt --pdf-engine=pdflatex

## Contributing

If you want to contribute to `QEDbase.jl` feel free to do so by opening an issue or send me a pull request. In order to keep the packages within `QuantumElectrodynamics.jl` coherent, consider visiting the general [contribution guide of `QuantumElectrodynamics.jl`](https://qedjl-project.github.io/QuantumElectrodynamics.jl/dev/dev_guide/).

## Credits and contributers

This work was partly funded by the Center for Advanced Systems Understanding (CASUS) that is financed by Germany’s Federal Ministry of Education and Research (BMBF) and by the Saxon Ministry for Science, Culture and Tourism (SMWK) with tax funds on the basis of the budget approved by the Saxon State Parliament.

The core code of the package `QEDbase.jl` is developed by a small team at the Center for Advanced Systems Understanding ([CASUS](https://www.casus.science)), namely

- Uwe Hernandez Acosta (u.hernandez@hzdr.de)

This package would not be possible without many contributions done from the community as well. For that we want send big thanks to:

- my Mate supplier
- the guy who will show me how to include the most recent contributers on github

## License

[MIT](LICENSE) © Uwe Hernandez Acosta
````

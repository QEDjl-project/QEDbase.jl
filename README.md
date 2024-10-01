# QEDbase

[![Doc Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/stable)
[![Doc Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/dev)
[![Build Status](https://gitlab.hzdr.de/qedjl/QEDbase.jl/badges/main/pipeline.svg)](https://gitlab.hzdr.de/qedjl/QEDbase.jl/pipelines)
[![Coverage](https://gitlab.hzdr.de/qedjl/QEDbase.jl/badges/main/coverage.svg)](https://gitlab.hzdr.de/qedjl/QEDbase.jl/commits/main)
[![Coverage](https://codecov.io/gh/qedjl/QEDbase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/qedjl/QEDbase.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package is part of the `QuantumElectrodynamics.jl` library. For the description of the interoperability with other packages of `QuantumElectrodynamics.jl` see [docs](https://qedjl-project.github.io/QuantumElectrodynamics.jl/dev/).

## Interfaces

- **Lorentz vectors:** enabling types to be used as Lorentz vector
- **Particles:** particles with a mass, a charge, and all that.
- **Computation models:** physical model, e.g. perturbative QED, to be used in
  calculations
- **Scattering processes:** generic description of a scattering process to be used in
  calculations.
- **Probabilities and cross-sections:** common building blocks for the calculation of differential probabilities and
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

## Contributing

If you want to contribute to `QEDbase.jl` feel free to do so by opening an issue or send us a pull request.
In order to keep the packages within `QuantumElectrodynamics.jl` coherent, consider visiting the
general [contribution guide of `QuantumElectrodynamics.jl`](https://qedjl-project.github.io/QuantumElectrodynamics.jl/stable/dev_guide/#Development-Guide).

## Credits and contributors

This work was partly funded by the Center for Advanced Systems Understanding (CASUS) that
is financed by Germany’s Federal Ministry of Education and Research (BMBF) and by the Saxon
Ministry for Science, Culture and Tourism (SMWK) with tax funds on the basis of the budget
approved by the Saxon State Parliament.

The core code of the package `QEDbase.jl` is developed by a small team at the Center for
Advanced Systems Understanding ([CASUS](https://www.casus.science)), namely

- Uwe Hernandez Acosta (CASU/HZDR, u.hernandez@hzdr.de)
- Anton Reinhard (CASUS/HZDR)
- Simeon Ehrig (CASUS/HZDR)
- Klaus Steiniger (CASUS/HZDR)

We also thank our former contributers

- Tom Jungnickel

## License

[MIT](LICENSE) © Uwe Hernandez Acosta

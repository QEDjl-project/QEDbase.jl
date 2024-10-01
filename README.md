# QEDbase

[![Doc Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/stable)
[![Doc Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/dev)
[![Build Status](https://gitlab.hzdr.de/qedjl/QEDbase.jl/badges/main/pipeline.svg)](https://gitlab.hzdr.de/qedjl/QEDbase.jl/pipelines)
[![Coverage](https://gitlab.hzdr.de/qedjl/QEDbase.jl/badges/main/coverage.svg)](https://gitlab.hzdr.de/qedjl/QEDbase.jl/commits/main)
[![Coverage](https://codecov.io/gh/qedjl/QEDbase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/qedjl/QEDbase.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

`QEDbase.jl` is a foundational package within the [`QuantumElectrodynamics.jl`](https://qedjl-project.github.io/QuantumElectrodynamics.jl/dev/)
library. It provides essential interfaces and building blocks for the computation of
quantum electrodynamics (QED) processes, facilitating interoperability with other packages in the suite.

For a detailed explanation of the integration with other `QuantumElectrodynamics.jl` packages,
please refer to the [documentation](https://qedjl-project.github.io/QuantumElectrodynamics.jl/main/).

## Main interfaces

- **Dirac Tensors**: Types that facilitate operations involving Dirac matrices and spinors.
- **Lorentz Vectors**: Types that facilitate operations involving Lorentz vectors.
- **Particle Representation**: Define particles with mass, charge, and other physical properties.
- **Computation Models**: Interfaces for implementing various physical models (e.g., perturbative or strong-field QED) for calculations.
- **Scattering Processes**: Generic descriptions of scattering processes for use in QED calculations.
- **Probabilities and Cross Sections**: Core components for calculating differential probabilities and cross-sections.
- **Phase Space Descriptions**: Utility functions to define and manage phase spaces and related points.

## Installation

To install the latest stable version of `QEDbase.jl`, use the Julia package manager within the REPL:

```julia
julia> using Pkg
julia> Pkg.add("QEDbase")
```

Alternatively, you can enter the Pkg prompt by pressing `]` in the Julia REPL and then run:

```julia
pkg> add QEDbase
```

## Contributing

Contributions are welcome! If you'd like to report a bug, suggest an enhancement, or contribute
code, please feel free to open an issue or submit a pull request.

To ensure consistency across the `QuantumElectrodynamics.jl` ecosystem, we encourage all contributors
to review the [QuantumElectrodynamics.jl contribution guide](https://qedjl-project.github.io/QuantumElectrodynamics.jl/stable/dev_guide/#Development-Guide).

## Credits and contributors

This work was partly funded by the Center for Advanced Systems Understanding (CASUS) that
is financed by Germany’s Federal Ministry of Education and Research (BMBF) and by the Saxon
Ministry for Science, Culture and Tourism (SMWK) with tax funds on the basis of the budget
approved by the Saxon State Parliament.

The core code of the package `QEDbase.jl` is developed by a small team at the Center for
Advanced Systems Understanding ([CASUS](https://www.casus.science)), namely

### Core Contributors

- **Uwe Hernandez Acosta** (CASUS/HZDR, [u.hernandez@hzdr.de](mailto:u.hernandez@hzdr.de))
- **Anton Reinhard** (CASUS/HZDR)
- **Simeon Ehrig** (CASUS/HZDR)
- **Klaus Steiniger** (CASUS/HZDR)

### Former Contributors

- **Tom Jungnickel**

We extend our sincere thanks to all contributors who have supported this project.

## License

[MIT](LICENSE) © Uwe Hernandez Acosta

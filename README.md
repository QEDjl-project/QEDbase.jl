# QEDbase


[![Doc Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/stable)
[![Doc Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qedjl-project.github.io/QEDbase.jl/dev)
[![Build Status](https://gitlab.com/hzdr/qedjl-project/QEDbase-jl/badges/-/pipeline.svg)](https://github.com/QEDjl-project/QEDbase.jl/actions)
[![Coverage](https://codebase.helmholtz.cloud/QEDjl/QEDbase.jl/badges/main/coverage.svg)](https://github.com/QEDjl-project/QEDbase.jl/commit/)
[![Coverage](https://codecov.io/gh/qedjl/QEDbase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/qedjl/QEDbase.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This is `QEDbase.jl`, a Julia package that provides the general data structures for calculations in relativistic particle physics.

This package is part of the `QED.jl` library. For the description of the interoperability with other packages of `QED.jl` see [docs](https://qedjl-project.github.io/QED.jl).

## Current features

- generic interface for Lorentz vectors
- concrete implementations of static and mutable Lorentz-vector/four-momentum types
- general Dirac bi-spinors, their adjoint counterpart as well as Dirac matrices
- particle spinors, i.e. solutions of Dirac's equation in momentum space
- Dirac's gamma matrices

## Installation

To install the current stable version of `QEDbase.jl` you may use the standard Julia package manager within the Julia REPL

```julia
julia> using Pkg

julia> Pkg.add("QEDbase")
```

or you use the Pkg prompt by hitting `]` within the Julia REPL and then type

```julia
(@v1.7) pkg> add QEDbase
```

To install the locally downloaded package on Windows, change to the parent directory and type within the Pkg prompt

```julia
(@v1.7) pkg> add ./QEDbase.jl
```

## Quickstart
#### Four-momentum
One can define a static four-momentum component-wise:

```julia
julia> using QEDbase

juila> mass = rand()*10

julia> px,py,pz = rand(3)

julia> E = sqrt(px^2 + py^2 + pz^2 + mass^2) # on-shell condition

julia> P = SFourMomentum(E,px,py,pz)
```

Such an `SFourMomentum` behaves like a four-element static array (with all the standard arithmetics), but with the `dot` product exchanged with the Minkowski product

```julia
julia> @assert dot(P,P) == P*P == getMass2(P) == P[1]^2 - sum(P[1:].^2)
```

Furthermore, the Lorentz-vector interface provides a lot of properties for such an `SFourMomentum`, e.g.

```julia

julia> @assert isapprox(getRapidity(mom), 0.5*log((E+pz)/(E-pz)))
julia> @assert isapprox(getPlus(mom), 0.5*(E+pz))
julia> @assert isapprox(getPerp(mom), px^2 + py^2)
```

and a lot more (see [here](www.docs-to-the-lorentz-interface-getter.jl) for a complete list). There is also a mutable version of a four-vector in `QEDbase.jl`, where the Lorentz-vector interface provides setters to different properties as well (see [here](www.docs-to-the-lorentz-interface-setter.jl) for details).

## Testing

After installation, it might be necessary to check if everything works properly. For that, you can run the unit tests by typing within the Julia REPL

```julia
julia> using Pkg
julia> using QEDbase
julia> Pkg.test("QEDbase")

...

Testing Running tests...
Test Summary: | Pass  Total
QEDbase.jl    |  468    468
     Testing QEDbase tests passed
```

If you see the last line, you can assume that `QEDbase.jl` works properly for you.

## Contributing

If you want to contribute to `QEDbase.jl`, feel free to do so by opening an issue or sending me a pull request. In order to keep the packages within `QED.jl` coherent, consider visiting the general [contribution guide of `QED.jl`](www.contribution-of-qed.jl).

## Credits and contributors

This work was partly funded by the Center for Advanced Systems Understanding (CASUS) which is financed by Germany’s Federal Ministry of Education and Research (BMBF) and by the Saxon Ministry for Science, Culture and Tourism (SMWK) with tax funds on the basis of the budget approved by the Saxon State Parliament.

The core code of the package `QEDbase.jl` is developed by a small team at the Center for Advanced Systems Understanding ([CASUS](https://www.casus.science)), namely

- Uwe Hernandez Acosta (u.hernandez@hzdr.de)

This package would not be possible without many contributions from the community as well. For that, we want to send big thanks to:

- my Mate supplier
- the guy who will show me how to include the most recent contributors on GitHub

## License

[MIT](LICENSE) © Uwe Hernandez Acosta

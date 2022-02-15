# QEDbase

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hernan68.gitlab.io/QEDbase.jl/dev)
[![Build Status](https://gitlab.hzdr.de/hernan68/QEDbase.jl/badges/main/pipeline.svg)](https://gitlab.hzdr.de/hernan68/QEDbase.jl/pipelines)
[![Coverage](https://gitlab.hzdr.de/hernan68/QEDbase.jl/badges/main/coverage.svg)](https://gitlab.hzdr.de/hernan68/QEDbase.jl/commits/main)
[![Coverage](https://codecov.io/gh/hernan68/QEDbase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/hernan68/QEDbase.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This is `QEDbase.jl`, a julia package which provides the general data structures for calculations in relativistic particle physics.

This package is part of the `QED.jl` library. For the description of the interoperability with other packages of `QED.jl` see [docs](www.docs-to-qed.jl).


#### Current features
- Lorentz vectors as well as  four momenta and four polarisation vectors
- general BiSpinors, its adjoint counterpart as well as Dirac matrices
- particle spinors, i.e. solutions of Dirac's equation in momentum space
- Dirac's gamma matrices

## Installation
To install the current stable version of `QEDbase.jl` you may use the standard julia package manager within the julia REPL

```julia
julia> using Pkg

julia> Pkg.add("QEDbase")
```
or you use the Pkg prompt by hitting `]` within the Julia REPL and then type

```julia
(@v1.7) pkg> add QEDbase
```

## Quickstart
#### Four momentum
One can define a four momentum component wise:

```julia
julia> using QEDbase

juila> mass = rand()*10

julia> px,py,pz = rand(3)

julia> E = sqrt(px^2 + py^2 + pz^2 + mass^2) # on-shell condition

julia> P = FourMomentum(E,px,py,pz)
```
Such `FourMomentum` behaves like a four element static array (with all the standard arithmetics), but with the `dot` product exchanged with the Minkowski product
```julia
julia> @assert dot(P,P) == P*P == mass_square(P) == P[1]^2 - sum(P[1:].^2)
```
## Testing
After installation it might be necessary to check if everything works properly. For that you can run the unittests by typing within the julia REPL

```julia
julia> using Pkg
julia> using QEDbase
julia> Pkg.test("QEDbase")

...

Testing Running tests...
Test Summary: | Pass  Total
QEDbase.jl    |  149    149
     Testing QEDbase tests passed
```

## Contributing
If you want to contribute to `QEDbase.jl` feel free to do so by opening an issue or send me a pull request. In order to keep the packages within `QED.jl` coherent, consider visiting the general [contribution guide of `QED.jl`](www.contribution-of-qed.jl).

## Credits and contributers
This work was partly funded by the Center for Advanced Systems Understanding (CASUS) that is financed by Germany’s Federal Ministry of Education and Research (BMBF) and by the Saxon Ministry for Science, Culture and Tourism (SMWK) with tax funds on the basis of the budget approved by the Saxon State Parliament.

The core code of the package `QEDbase.jl` is developed by a small team at the Center for Advanced Systems Understanding ([CASUS](https://www.casus.science)), namely

- Uwe Hernandez Acosta (u.hernandez@hzdr.de)

This package would not be possible without many contributions done from the commuity as well. For that we want send big thanks to:

- my Mate supplier
- the guy who will show me how to include the most recent contributers on github

## License

[MIT](LICENSE) © Uwe Hernandez Acosta
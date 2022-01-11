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
To install the current stable version of `QEDtemplate.jl` you may use the standard julia package manager within the julia REPL

```julia
julia> using Pkg

julia> Pkg.add("QEDbase")
```
or you use the Pkg promt by hitting `]` within the Julia REPL and then type

```julia
(@v1.6) pkg> add QEDbase
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

With them its possible to print out the _awesomeness_:

```julia
julia> print_awesome(awesome_physics)
Your physics is awesome!

julia> print_awesome(less_awesome_physics)
Others physics is less awesome.

```


## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).

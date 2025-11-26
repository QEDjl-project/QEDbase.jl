# Probability and Cross Section

## Interface

```@meta
CurrentModule = QEDbase
```

```@docs
_incident_flux
_matrix_element
_matrix_element_square
_matrix_element_square_sum
```

## Differential and total probability

```@docs
differential_probability
unsafe_differential_probability
total_probability
```

## Differential and total cross section

```@docs
differential_cross_section
unsafe_differential_cross_section
total_cross_section
```

## Vectorized interface

Additionally to the scalar implementations, for the differential probabilities and cross section, vectorized implementations are provided. These are implemented using [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl) for arbitrary phase space points. This allows easy usage of GPUs from multiple vendors. If a better vectorized version is available (or necessary because of compilation issues), the non-kernel version should be specialized, and implement **all** of the 4 functions.

```@docs
differential_probability!
differential_probability_kernel!
unsafe_differential_probability!
unsafe_differential_probability_kernel!
differential_cross_section!
differential_cross_section_kernel!
unsafe_differential_cross_section!
unsafe_differential_cross_section_kernel!
```

"""
    abstract type AbstractMockMomentum{T} <: AbstractFourMomentum

An abstract type representing a mock four-momentum.

This serves as a base type for mock momentum representations, parameterized by
`T`, which defines the numerical type of the momentum components.
"""
abstract type AbstractMockMomentum{T} <: AbstractFourMomentum end

"""
    struct MockMomentum{T} <: AbstractMockMomentum{T}

A concrete implementation of a four-momentum with immutable components.

# Fields
- `E::T`: Energy component.
- `px::T`: Momentum component in the x-direction.
- `py::T`: Momentum component in the y-direction.
- `pz::T`: Momentum component in the z-direction.

# Example
```julia
p = MockMomentum(10.0, 1.0, 2.0, 3.0)
```
"""
struct MockMomentum{T} <: AbstractMockMomentum{T}
    E::T
    px::T
    py::T
    pz::T
end

function StaticArrays.similar_type(
    ::Type{A}, ::Type{T}, ::Size{S}
) where {A<:MockMomentum,T,S}
    return MockMomentum{T}
end

QEDbase.getT(lv::MockMomentum) = lv.E
QEDbase.getX(lv::MockMomentum) = lv.px
QEDbase.getY(lv::MockMomentum) = lv.py
QEDbase.getZ(lv::MockMomentum) = lv.pz

QEDbase.register_LorentzVectorLike(MockMomentum)

"""
    mutable struct MockMomentumMutable{T} <: AbstractMockMomentum{T}

A concrete implementation of a four-momentum with mutable components.

# Fields
- `E::T`: Energy component.
- `px::T`: Momentum component in the x-direction.
- `py::T`: Momentum component in the y-direction.
- `pz::T`: Momentum component in the z-direction.

Unlike `MockMomentum`, this struct allows modifying individual momentum components.

# Example
```julia
p = MockMomentumMutable(10.0, 1.0, 2.0, 3.0)
QEDbase.setT!(p, 12.0)  # Modify energy
```
"""
mutable struct MockMomentumMutable{T} <: AbstractMockMomentum{T}
    E::T
    px::T
    py::T
    pz::T
end

function StaticArrays.similar_type(
    ::Type{A}, ::Type{T}, ::Size{S}
) where {A<:MockMomentumMutable,T,S}
    return MockMomentumMutable{T}
end

QEDbase.getT(lv::MockMomentumMutable) = lv.E
QEDbase.getX(lv::MockMomentumMutable) = lv.px
QEDbase.getY(lv::MockMomentumMutable) = lv.py
QEDbase.getZ(lv::MockMomentumMutable) = lv.pz

QEDbase.setT!(lv::MockMomentumMutable, E) = (lv.E = E)
QEDbase.setX!(lv::MockMomentumMutable, px) = (lv.px = px)
QEDbase.setY!(lv::MockMomentumMutable, py) = (lv.py = py)
QEDbase.setZ!(lv::MockMomentumMutable, pz) = (lv.pz = pz)

QEDbase.register_LorentzVectorLike(MockMomentumMutable)

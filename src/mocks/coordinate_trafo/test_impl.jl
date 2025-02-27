
"""
    MockCoordinateTrafo <: AbstractCoordinateTransformation

A mock coordinate transformation that scales all momentum components by a factor of 2.

This transformation internally calls [`_groundtruth_coord_trafo`](@ref).

# Usage
This type is used as a coordinate transformation within the context of `QEDbase`,
applying `_groundtruth_coord_trafo` to momenta.

# Example
```julia
p = MockMomentum(rand(4))
trafo = MockCoordinateTrafo()
transformed_p = trafo(p)
```
"""
struct MockCoordinateTrafo <: AbstractCoordinateTransformation end
QEDbase._transform(::MockCoordinateTrafo, p) = _groundtruth_coord_trafo(p)

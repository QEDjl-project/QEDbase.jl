
struct MockCoordinateTrafo <: AbstractCoordinateTransformation end
QEDbase._transform(::MockCoordinateTrafo, p) = _groundtruth_coord_trafo(p)

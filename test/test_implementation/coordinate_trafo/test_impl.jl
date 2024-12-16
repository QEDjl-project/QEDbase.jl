
struct TestCoordinateTrafo <: AbstractCoordinateTransformation end
QEDbase._transform(::TestCoordinateTrafo, p) = _groundtruth_coord_trafo(p)

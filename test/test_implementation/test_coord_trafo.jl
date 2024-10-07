
struct TestCoordTrafo <: AbstractCoordinateTransformation end
QEDbase._transform(::TestCoordTrafo, p) = _groundtruth_coord_trafo(p)

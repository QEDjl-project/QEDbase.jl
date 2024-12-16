
struct TestModel <: AbstractModelDefinition end
QEDbase.fundamental_interaction_type(::TestModel) = _groundtruth_interaction_type()

struct TestModel_FAIL <: AbstractModelDefinition end

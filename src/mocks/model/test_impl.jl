
struct MockModel <: AbstractModelDefinition end
QEDbase.fundamental_interaction_type(::MockModel) = _groundtruth_interaction_type()

struct MockModel_FAIL <: AbstractModelDefinition end

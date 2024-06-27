
struct TestModel <: AbstractModelDefinition end
QEDprocesses.fundamental_interaction_type(::TestModel) = :test_interaction

struct TestModel_FAIL <: AbstractModelDefinition end

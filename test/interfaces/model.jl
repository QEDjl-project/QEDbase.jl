using QEDbase

struct TestModel <: AbstractModelDefinition end
QEDbase.fundamental_interaction_type(::TestModel) = :test_interaction

struct TestModel_FAIL <: AbstractModelDefinition end

@testset "hard interface" begin
    TESTMODEL = TestModel()
    @test fundamental_interaction_type(TESTMODEL) == :test_interaction
end

@testset "interface fail" begin
    TESTMODEL_FAIL = TestModel_FAIL()
    @test_throws MethodError fundamental_interaction_type(TESTMODEL_FAIL)
end

@testset "broadcast" begin
    test_func(model) = model
    TESTMODEL = TestModel()
    @test test_func.(TESTMODEL) == TESTMODEL
end

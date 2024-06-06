using QEDbase

include("../test_implementation/TestImplementation.jl")

@testset "hard interface" begin
    TESTMODEL = TestImplementation.TestModel()
    @test fundamental_interaction_type(TESTMODEL) == :test_interaction
end

@testset "interface fail" begin
    TESTMODEL_FAIL = TestImplementation.TestModel_FAIL()
    @test_throws MethodError fundamental_interaction_type(TESTMODEL_FAIL)
end

@testset "broadcast" begin
    test_func(model) = model
    TESTMODEL = TestImplementation.TestModel()
    @test test_func.(TESTMODEL) == TESTMODEL
end

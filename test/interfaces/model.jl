using QEDbase

include("../test_implementation/TestImplementation.jl")
using .TestImplementation: TestModel, TestModel_FAIL

@testset "hard interface" begin
    TESTMODEL = @inferred TestModel()
    @test @inferred fundamental_interaction_type(TESTMODEL) ==
        TestImplementation._groundtruth_interaction_type()
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

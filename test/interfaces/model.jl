using QEDbase
using QEDbase.Mocks

@testset "hard interface" begin
    TESTMODEL = @inferred MockModel()
    @test @inferred fundamental_interaction_type(TESTMODEL) ==
        Mocks._groundtruth_interaction_type()
end

@testset "interface fail" begin
    TESTMODEL_FAIL = MockModel_FAIL()
    @test_throws MethodError fundamental_interaction_type(TESTMODEL_FAIL)
end

@testset "broadcast" begin
    test_func(model) = model
    TESTMODEL = MockModel()
    @test test_func.(TESTMODEL) == TESTMODEL
end

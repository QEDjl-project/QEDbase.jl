
using Random
using QEDbase

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("../test_implementation/TestImplementation.jl")
using .TestImplementation

MOM_TYPE = TestMomentum{Float64}
TEST_MOM = MOM_TYPE(rand(RNG, 4))

@testset "particle properties" begin
    @testset "particle" begin
        @test is_particle(TestFermion()) == true
        @test is_particle(TestMasslessFermion()) == true
        @test is_particle(TestBoson()) == true
        @test is_particle(TestMasslessBoson()) == true
    end

    @testset "anti particle" begin
        @test is_anti_particle(TestFermion()) == false
        @test is_anti_particle(TestMasslessFermion()) == false
        @test is_anti_particle(TestBoson()) == false
        @test is_anti_particle(TestMasslessBoson()) == false
    end

    @testset "fermion" begin
        @test is_fermion(TestFermion()) == true
        @test is_fermion(TestMasslessFermion()) == true
        @test is_fermion(TestBoson()) == false
        @test is_fermion(TestMasslessBoson()) == false
    end

    @testset "boson" begin
        @test is_boson(TestFermion()) == false
        @test is_boson(TestMasslessFermion()) == false
        @test is_boson(TestBoson()) == true
        @test is_boson(TestMasslessBoson()) == true
    end

    @testset "mass" begin
        @test mass(TestFermion()) == TestImplementation._MASS_TEST_FERMION
        @test mass(TestMasslessFermion()) == 0.0
        @test mass(TestBoson()) == TestImplementation._MASS_TEST_BOSON
        @test mass(TestMasslessBoson()) == 0.0
    end

    @testset "charge" begin
        @test charge(TestFermion()) == TestImplementation._CHARGE_TEST_FERMION
        @test charge(TestMasslessFermion()) == TestImplementation._CHARGE_TEST_FERMION
        @test charge(TestBoson()) == TestImplementation._CHARGE_TEST_BOSON
        @test charge(TestMasslessBoson()) == TestImplementation._CHARGE_TEST_BOSON
    end

    @testset "propagator" begin
        @test propagator(TestFermion(), TEST_MOM) ==
            TestImplementation._groundtruth_fermion_propagator(TEST_MOM)
        @test propagator(TestMasslessFermion(), TEST_MOM) ==
            TestImplementation._groundtruth_fermion_propagator(TEST_MOM)
        @test propagator(TestBoson(), TEST_MOM) ==
            TestImplementation._groundtruth_boson_propagator(TEST_MOM)
        @test propagator(TestMasslessBoson(), TEST_MOM) ==
            TestImplementation._groundtruth_boson_propagator(TEST_MOM)
    end

    @testset "base state" begin
        @testset "$DIR" for DIR in (Incoming(), Outgoing())
            @testset "fermion $SPIN" for SPIN in (SpinUp(), SpinDown())
                @test base_state(TestFermion(), DIR, TEST_MOM, SPIN) ==
                    TestImplementation._groundtruth_fermion_base_state(
                    DIR, TEST_MOM, SPIN
                )
                @test base_state(TestMasslessFermion(), DIR, TEST_MOM, SPIN) ==
                    TestImplementation._groundtruth_massless_fermion_base_state(
                    DIR, TEST_MOM, SPIN
                )
            end
            @testset "boson $POL" for POL in (PolX(), PolY())
                @test base_state(TestBoson(), DIR, TEST_MOM, POL) ==
                    TestImplementation._groundtruth_boson_base_state(DIR, TEST_MOM, POL)
                @test base_state(TestMasslessBoson(), DIR, TEST_MOM, POL) ==
                    TestImplementation._groundtruth_massless_boson_base_state(
                    DIR, TEST_MOM, POL
                )
            end
        end
    end
end

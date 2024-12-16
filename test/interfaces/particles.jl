
using Random
using QEDbase

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

include("../test_implementation/TestImplementation.jl")
using .TestImplementation

@testset "particle properties" begin
    @testset "particle" begin
        @test is_particle(TestFermion()) == true
        @test is_particle(TestMasslessFermion()) == true
        @test is_particle(TestBoson()) == true
        @test is_particle(TestMasslessBoson()) == true
    end

    @testset "particle" begin
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
end

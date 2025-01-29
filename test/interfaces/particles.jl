
using Random
using QEDbase
using QEDbase.Mocks

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

@testset "particle properties" begin
    @testset "particle" begin
        @test is_particle(MockFermion()) == true
        @test is_particle(MockMasslessFermion()) == true
        @test is_particle(MockBoson()) == true
        @test is_particle(MockMasslessBoson()) == true
    end

    @testset "anti particle" begin
        @test is_anti_particle(MockFermion()) == false
        @test is_anti_particle(MockMasslessFermion()) == false
        @test is_anti_particle(MockBoson()) == false
        @test is_anti_particle(MockMasslessBoson()) == false
    end

    @testset "fermion" begin
        @test is_fermion(MockFermion()) == true
        @test is_fermion(MockMasslessFermion()) == true
        @test is_fermion(MockBoson()) == false
        @test is_fermion(MockMasslessBoson()) == false
    end

    @testset "boson" begin
        @test is_boson(MockFermion()) == false
        @test is_boson(MockMasslessFermion()) == false
        @test is_boson(MockBoson()) == true
        @test is_boson(MockMasslessBoson()) == true
    end

    @testset "mass" begin
        @test mass(MockFermion()) == Mocks._MASS_TEST_FERMION
        @test mass(MockMasslessFermion()) == 0.0
        @test mass(MockBoson()) == Mocks._MASS_TEST_BOSON
        @test mass(MockMasslessBoson()) == 0.0
    end

    @testset "charge" begin
        @test charge(MockFermion()) == Mocks._CHARGE_TEST_FERMION
        @test charge(MockMasslessFermion()) == Mocks._CHARGE_TEST_FERMION
        @test charge(MockBoson()) == Mocks._CHARGE_TEST_BOSON
        @test charge(MockMasslessBoson()) == Mocks._CHARGE_TEST_BOSON
    end

    @testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float16, Float32, Float64)
        TEST_MOM = MockMomentum{MOM_EL_TYPE}(rand(RNG, 4))
        @testset "propagator" begin
            @test propagator(MockFermion(), TEST_MOM) ==
                Mocks._groundtruth_fermion_propagator(TEST_MOM)
            @test propagator(MockMasslessFermion(), TEST_MOM) ==
                Mocks._groundtruth_fermion_propagator(TEST_MOM)
            @test propagator(MockBoson(), TEST_MOM) ==
                Mocks._groundtruth_boson_propagator(TEST_MOM)
            @test propagator(MockMasslessBoson(), TEST_MOM) ==
                Mocks._groundtruth_boson_propagator(TEST_MOM)
        end

        @testset "base state" begin
            @testset "$DIR" for DIR in (Incoming(), Outgoing())
                @testset "fermion $SPIN" for SPIN in (SpinUp(), SpinDown())
                    @test base_state(MockFermion(), DIR, TEST_MOM, SPIN) ==
                        Mocks._groundtruth_fermion_base_state(DIR, TEST_MOM, SPIN)
                    @test base_state(MockMasslessFermion(), DIR, TEST_MOM, SPIN) ==
                        Mocks._groundtruth_massless_fermion_base_state(
                        DIR, TEST_MOM, SPIN
                    )
                end
                @testset "boson $POL" for POL in (PolX(), PolY())
                    @test base_state(MockBoson(), DIR, TEST_MOM, POL) ==
                        Mocks._groundtruth_boson_base_state(DIR, TEST_MOM, POL)
                    @test base_state(MockMasslessBoson(), DIR, TEST_MOM, POL) ==
                        Mocks._groundtruth_massless_boson_base_state(DIR, TEST_MOM, POL)
                end
            end
        end
    end
end

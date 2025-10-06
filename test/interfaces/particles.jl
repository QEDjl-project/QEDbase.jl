using Random
using QEDbase
using QEDbase.Mocks

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

BUF = IOBuffer()

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

    @testset "mass & charge in $FLOAT_T" for FLOAT_T in (Float16, Float32, Float64)
        @testset "mass" begin
            @test mass(FLOAT_T, MockFermion()) == FLOAT_T(Mocks._MASS_TEST_FERMION)
            @test mass(FLOAT_T, MockMasslessFermion()) == zero(FLOAT_T)
            @test mass(FLOAT_T, MockBoson()) == FLOAT_T(Mocks._MASS_TEST_BOSON)
            @test mass(FLOAT_T, MockMasslessBoson()) == zero(FLOAT_T)

            @test mass(FLOAT_T, MockFermion()) isa FLOAT_T
            @test mass(FLOAT_T, MockMasslessFermion()) isa FLOAT_T
            @test mass(FLOAT_T, MockBoson()) isa FLOAT_T
            @test mass(FLOAT_T, MockMasslessBoson()) isa FLOAT_T
        end

        @testset "charge" begin
            @test charge(FLOAT_T, MockFermion()) == FLOAT_T(Mocks._CHARGE_TEST_FERMION)
            @test charge(FLOAT_T, MockMasslessFermion()) ==
                FLOAT_T(Mocks._CHARGE_TEST_FERMION)
            @test charge(FLOAT_T, MockBoson()) == FLOAT_T(Mocks._CHARGE_TEST_BOSON)
            @test charge(FLOAT_T, MockMasslessBoson()) == FLOAT_T(Mocks._CHARGE_TEST_BOSON)

            @test charge(FLOAT_T, MockFermion()) isa FLOAT_T
            @test charge(FLOAT_T, MockMasslessFermion()) isa FLOAT_T
            @test charge(FLOAT_T, MockBoson()) isa FLOAT_T
            @test charge(FLOAT_T, MockMasslessBoson()) isa FLOAT_T
        end
    end

    @testset "mass default type" begin
        @test mass(MockFermion()) isa Float64
        @test mass(MockMasslessFermion()) isa Float64
        @test mass(MockBoson()) isa Float64
        @test mass(MockMasslessBoson()) isa Float64
    end

    @testset "charge default type" begin
        @test charge(MockFermion()) isa Float64
        @test charge(MockMasslessFermion()) isa Float64
        @test charge(MockBoson()) isa Float64
        @test charge(MockMasslessBoson()) isa Float64
    end

    @testset "show" begin
        @testset "$PART" for PART in QEDbase.Mocks.PARTICLE_SET
            take!(BUF)
            print(BUF, PART)
            @test String(take!(BUF)) == join(
                lowercase.(QEDbase._split_uppercase(string(nameof(typeof(PART))))), " "
            )
        end
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

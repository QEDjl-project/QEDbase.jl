using QEDbase
using Random

FERMION_STATES_GROUNDTRUTH_FACTORY = Dict(
    (Incoming, Electron) => IncomingFermionSpinor,
    (Outgoing, Electron) => OutgoingFermionSpinor,
    (Incoming, Positron) => IncomingAntiFermionSpinor,
    (Outgoing, Positron) => OutgoingAntiFermionSpinor,
)

rng = MersenneTwister(708583836976)
x, y, z = rand(rng, 3)

@testset "fermion likes" begin
    @testset "fermion" begin
        struct TestFermion <: Fermion end
        @test is_fermion(TestFermion())
        @test is_particle(TestFermion())
        @test !is_anti_particle(TestFermion())

        mom = SFourMomentum(sqrt(x^2 + y^2 + z^2 + mass(Electron())^2), x, y, z)
        @testset "$P $D" for (P, D) in
                             Iterators.product((Electron, Positron), (Incoming, Outgoing))
            particle_mass = mass(P())
            groundtruth_states = FERMION_STATES_GROUNDTRUTH_FACTORY[(D, P)](
                mom, particle_mass
            )
            groundtruth_tuple = SVector(groundtruth_states(1), groundtruth_states(2))
            @test base_state(P(), D(), mom, AllSpin()) == groundtruth_tuple
            @test base_state(P(), D(), mom, SpinUp()) == groundtruth_tuple[1]
            @test base_state(P(), D(), mom, SpinDown()) == groundtruth_tuple[2]
        end
    end

    @testset "antifermion" begin
        struct TestAntiFermion <: AntiFermion end
        @test is_fermion(TestAntiFermion())
        @test !is_particle(TestAntiFermion())
        @test is_anti_particle(TestAntiFermion())
    end

    @testset "majorana fermion" begin
        struct TestMajoranaFermion <: MajoranaFermion end
        @test is_fermion(TestMajoranaFermion())
        @test is_particle(TestMajoranaFermion())
        @test is_anti_particle(TestMajoranaFermion())
    end

    @testset "electron" begin
        @test is_fermion(Electron())
        @test is_particle(Electron())
        @test !is_anti_particle(Electron())
        @test mass(Electron()) == 1.0
        @test charge(Electron()) == -1.0
    end

    @testset "positron" begin
        @test is_fermion(Positron())
        @test !is_particle(Positron())
        @test is_anti_particle(Positron())
        @test mass(Positron()) == 1.0
        @test charge(Positron()) == 1.0
    end
end

@testset "boson likes" begin
    @testset "boson" begin
        struct TestBoson <: Boson end
        @test !is_fermion(TestBoson())
        @test is_boson(TestBoson())
        @test is_particle(TestBoson())
        @test !is_anti_particle(TestBoson())
    end

    @testset "antiboson" begin
        struct TestAntiBoson <: AntiBoson end
        @test !is_fermion(TestAntiBoson())
        @test is_boson(TestAntiBoson())
        @test !is_particle(TestAntiBoson())
        @test is_anti_particle(TestAntiBoson())
    end

    @testset "majorana boson" begin
        struct TestMajoranaBoson <: MajoranaBoson end
        @test !is_fermion(TestMajoranaBoson())
        @test is_boson(TestMajoranaBoson())
        @test is_particle(TestMajoranaBoson())
        @test is_anti_particle(TestMajoranaBoson())
    end

    @testset "photon" begin
        @test !is_fermion(Photon())
        @test is_boson(Photon())
        @test is_particle(Photon())
        @test is_anti_particle(Photon())
        @test charge(Photon()) == 0.0
        @test mass(Photon()) == 0.0

        mom = SFourMomentum(sqrt(x^2 + y^2 + z^2 + mass(Photon())^2), x, y, z)
        @testset "$D" for D in [Incoming, Outgoing]
            both_photon_states = base_state(Photon(), D(), mom, AllPolarization())

            # property test the photon states
            @test isapprox((both_photon_states[1] * mom), 0.0, atol=ATOL)
            @test isapprox((both_photon_states[2] * mom), 0.0, atol=ATOL)
            @test isapprox((both_photon_states[1] * both_photon_states[1]), -1.0)
            @test isapprox((both_photon_states[2] * both_photon_states[2]), -1.0)
            @test isapprox((both_photon_states[1] * both_photon_states[2]), 0.0, atol=ATOL)

            # test the single polarization states
            @test base_state(Photon(), D(), mom, PolarizationX()) == both_photon_states[1]
            @test base_state(Photon(), D(), mom, PolarizationY()) == both_photon_states[2]
            @test base_state(Photon(), D(), mom, PolX()) == both_photon_states[1]
            @test base_state(Photon(), D(), mom, PolY()) == both_photon_states[2]
        end
    end
end

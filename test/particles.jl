using QEDbase
using StaticArrays
using Random

include("utils.jl")

FERMION_STATES_GROUNDTRUTH_FACTORY = Dict(
    (Incoming, Electron) => IncomingFermionSpinor,
    (Outgoing, Electron) => OutgoingFermionSpinor,
    (Incoming, Positron) => IncomingAntiFermionSpinor,
    (Outgoing, Positron) => OutgoingAntiFermionSpinor,
)

RNG = MersenneTwister(708583836976)
ATOL = eps()
RTOL = 0.0
PHOTON_ENERGIES = (0.0, rand(RNG), rand(RNG) * 10)
COS_THETAS = (-1.0, -rand(RNG), 0.0, rand(RNG), 1.0)
# check every quadrant
PHIS = (
    0.0,
    rand(RNG) * pi / 2,
    pi / 2,
    (1.0 + rand(RNG)) * pi / 2,
    pi,
    (2 + rand(RNG)) * pi / 2,
    3 * pi / 2,
    (3 + rand(RNG)) * pi / 2,
    2 * pi,
)

X, Y, Z = rand(RNG, 3)

# test function to test scalar broadcasting
test_broadcast(x::AbstractParticle) = x

@testset "fermion likes" begin
    @testset "fermion" begin
        struct TestFermion <: Fermion end
        @test is_fermion(TestFermion())
        @test is_particle(TestFermion())
        @test !is_anti_particle(TestFermion())
        @test test_broadcast.(TestFermion()) == TestFermion()

        @testset "$p $d" for (p, d) in
                             Iterators.product((Electron, Positron), (Incoming, Outgoing))
            mom = SFourMomentum(sqrt(mass(p()) + X^2 + Y^2 + Z^2), X, Y, Z)
            particle_mass = mass(p())
            groundtruth_states = FERMION_STATES_GROUNDTRUTH_FACTORY[(d, p)](
                mom, particle_mass
            )
            groundtruth_tuple = SVector(groundtruth_states(1), groundtruth_states(2))
            @test base_state(p(), d(), mom, AllSpin()) == groundtruth_tuple
            @test base_state(p(), d(), mom, SpinUp()) == groundtruth_tuple[1]
            @test base_state(p(), d(), mom, SpinDown()) == groundtruth_tuple[2]

            @test QEDbase._as_svec(base_state(p(), d(), mom, AllSpin())) isa SVector
            @test QEDbase._as_svec(base_state(p(), d(), mom, SpinUp())) isa SVector
            @test QEDbase._as_svec(base_state(p(), d(), mom, SpinDown())) isa SVector

            @test QEDbase._as_svec(base_state(p(), d(), mom, AllSpin())) ==
                groundtruth_tuple
            @test QEDbase._as_svec(base_state(p(), d(), mom, SpinUp()))[1] ==
                groundtruth_tuple[1]
            @test QEDbase._as_svec(base_state(p(), d(), mom, SpinDown()))[1] ==
                groundtruth_tuple[2]
        end
    end

    @testset "antifermion" begin
        struct TestAntiFermion <: AntiFermion end
        @test is_fermion(TestAntiFermion())
        @test !is_particle(TestAntiFermion())
        @test is_anti_particle(TestAntiFermion())
        @test test_broadcast.(TestAntiFermion()) == TestAntiFermion()
    end

    @testset "majorana fermion" begin
        struct TestMajoranaFermion <: MajoranaFermion end
        @test is_fermion(TestMajoranaFermion())
        @test is_particle(TestMajoranaFermion())
        @test is_anti_particle(TestMajoranaFermion())
        @test test_broadcast.(TestMajoranaFermion()) == TestMajoranaFermion()
    end

    @testset "electron" begin
        @test is_fermion(Electron())
        @test is_particle(Electron())
        @test !is_anti_particle(Electron())
        @test mass(Electron()) == 1.0
        @test charge(Electron()) == -1.0
        @test test_broadcast.(Electron()) == Electron()
    end

    @testset "positron" begin
        @test is_fermion(Positron())
        @test !is_particle(Positron())
        @test is_anti_particle(Positron())
        @test mass(Positron()) == 1.0
        @test charge(Positron()) == 1.0
        @test test_broadcast.(Positron()) == Positron()
    end
end

@testset "boson likes" begin
    @testset "boson" begin
        struct TestBoson <: Boson end
        @test !is_fermion(TestBoson())
        @test is_boson(TestBoson())
        @test is_particle(TestBoson())
        @test !is_anti_particle(TestBoson())
        @test test_broadcast.(TestBoson()) == TestBoson()
    end

    @testset "antiboson" begin
        struct TestAntiBoson <: AntiBoson end
        @test !is_fermion(TestAntiBoson())
        @test is_boson(TestAntiBoson())
        @test !is_particle(TestAntiBoson())
        @test is_anti_particle(TestAntiBoson())
        @test test_broadcast.(TestAntiBoson()) == TestAntiBoson()
    end

    @testset "majorana boson" begin
        struct TestMajoranaBoson <: MajoranaBoson end
        @test !is_fermion(TestMajoranaBoson())
        @test is_boson(TestMajoranaBoson())
        @test is_particle(TestMajoranaBoson())
        @test is_anti_particle(TestMajoranaBoson())
        @test test_broadcast.(TestMajoranaBoson()) == TestMajoranaBoson()
    end
end

@testset "photon" begin
    @test !is_fermion(Photon())
    @test is_boson(Photon())
    @test is_particle(Photon())
    @test is_anti_particle(Photon())
    @test charge(Photon()) == 0.0
    @test mass(Photon()) == 0.0
    @test test_broadcast.(Photon()) == Photon()

    @testset "$D" for D in [Incoming, Outgoing]
        @testset "$om $cth $phi" for (om, cth, phi) in
                                     Iterators.product(PHOTON_ENERGIES, COS_THETAS, PHIS)
            #@testset "$x $y $z" for (x,y,z) in Iterators.product(X_arr,Y_arr,Z_arr)

            mom = SFourMomentum(_cartesian_coordinates(om, om, cth, phi))
            both_photon_states = base_state(Photon(), D(), mom, AllPolarization())

            # property test the photon states
            @test isapprox((both_photon_states[1] * mom), 0.0, atol=ATOL, rtol=RTOL)
            @test isapprox((both_photon_states[2] * mom), 0.0, atol=ATOL, rtol=RTOL)
            @test isapprox(
                (both_photon_states[1] * both_photon_states[1]), -1.0, atol=ATOL, rtol=RTOL
            )
            @test isapprox(
                (both_photon_states[2] * both_photon_states[2]), -1.0, atol=ATOL, rtol=RTOL
            )
            @test isapprox(
                (both_photon_states[1] * both_photon_states[2]), 0.0, atol=ATOL, rtol=RTOL
            )

            # test the single polarization states
            @test base_state(Photon(), D(), mom, PolarizationX()) == both_photon_states[1]
            @test base_state(Photon(), D(), mom, PolarizationY()) == both_photon_states[2]
            @test base_state(Photon(), D(), mom, PolX()) == both_photon_states[1]
            @test base_state(Photon(), D(), mom, PolY()) == both_photon_states[2]

            @test QEDbase._as_svec(base_state(Photon(), D(), mom, PolX())) isa SVector
            @test QEDbase._as_svec(base_state(Photon(), D(), mom, PolY())) isa SVector
            @test QEDbase._as_svec(base_state(Photon(), D(), mom, AllPol())) isa SVector

            @test QEDbase._as_svec(base_state(Photon(), D(), mom, PolX()))[1] ==
                both_photon_states[1]
            @test QEDbase._as_svec(base_state(Photon(), D(), mom, PolY()))[1] ==
                both_photon_states[2]
            @test QEDbase._as_svec(base_state(Photon(), D(), mom, AllPol()))[1] ==
                both_photon_states[1]
            @test QEDbase._as_svec(base_state(Photon(), D(), mom, AllPol()))[2] ==
                both_photon_states[2]
        end
    end
end

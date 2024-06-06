using QEDbase
using StaticArrays
using Random

# test function to test scalar broadcasting
test_broadcast(x::AbstractParticle) = x
test_broadcast(x::ParticleDirection) = x
test_broadcast(x::AbstractSpinOrPolarization) = x

@testset "scalar broadcasting" begin
    @testset "directions" begin
        @testset "$dir" for dir in (Incoming(), Outgoing())
            @test test_broadcast.(dir) == dir
        end
    end

    @testset "spins and polarization" begin
        @testset "$spin_or_pol" for spin_or_pol in (
            SpinUp(), SpinDown(), AllSpin(), PolX(), PolY(), AllPol()
        )
            @test test_broadcast.(spin_or_pol) == spin_or_pol
        end
    end
end

@testset "multiplicity of spins or pols" begin
    @testset "single" begin
        @testset "$spin_or_pol" for spin_or_pol in (SpinUp(), SpinDown(), PolX(), PolY())
            @test multiplicity(spin_or_pol) == 1
        end
    end
    @testset "multiple" begin
        @testset "$spin_or_pol" for spin_or_pol in (AllSpin(), AllPol())
            @test multiplicity(spin_or_pol) == 2
        end
    end
end

@testset "fermion likes" begin
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

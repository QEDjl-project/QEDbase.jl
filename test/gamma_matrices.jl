
using LinearAlgebra
using Random

function _gamma_anticommutator(i,j)
    return GAMMA[i]*GAMMA[j] + GAMMA[j]*GAMMA[i]
end

function _gamma_sandwich(nu::Int64)
    return GAMMA*(GAMMA[nu]*GAMMA)
end

METRIC = Diagonal([1,-1,-1,-1])
EYE = one(DiracMatrix)


@testset "gamma matrices" begin

    rng = MersenneTwister(42)

    @testset "commutator" begin

        for (i,j) in Iterators.product(1:4,1:4)
            @test isapprox(_gamma_anticommutator(i,j),2*METRIC[i,j]*EYE)
        end
    end #commutator

    @testset "Minkowski product" begin
        @test GAMMA*GAMMA == 4*one(DiracMatrix)
    end # Minkowski product

    @testset "gamma sandwich" begin
        @test SLorentzVector([_gamma_sandwich(nu) for nu in 1:4]) == -2*GAMMA
    end # gamma sandwich

    @testset "adjoints" begin
        @test adjoint(GAMMA[1])==GAMMA[1]
        for i in 2:4
            @test adjoint(GAMMA[i])==-GAMMA[i]
        end

        @test SLorentzVector([adjoint(GAMMA[nu]) for nu in 1:4]) == GAMMA[1]*(GAMMA*GAMMA[1])
    end # adjoints

    @testset "interface SLorentzVector" begin
        a = SLorentzVector(rand(rng,4))
        b = SLorentzVector(rand(rng,4))

        a_slash = GAMMA*a
        b_slash = GAMMA*b

        @test isapprox(tr(a_slash*b_slash), 4*a*b)
        @test isapprox(a_slash*a_slash,(a*a)*one(DiracMatrix))
        @test isapprox(GAMMA*(a_slash*GAMMA),-2*a_slash)
    end # interface SLorentzVector

    @testset "Feynman slash" begin
        a = SLorentzVector(rand(rng,4) + 1im*rand(rng,4))

        @test isapprox(slashed(a),GAMMA*a)
        @test isapprox(slashed(a),slashed(DiracGammaRepresentation,a))
    end
end

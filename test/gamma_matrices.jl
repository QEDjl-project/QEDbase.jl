
using LinearAlgebra
using Random
using SparseArrays

function _gamma_anticommutator(i, j)
    return GAMMA[i] * GAMMA[j] + GAMMA[j] * GAMMA[i]
end

function _gamma_sandwich(nu::Int64)
    return GAMMA * (GAMMA[nu] * GAMMA)
end

METRIC = Diagonal([1, -1, -1, -1])
EYE = one(DiracMatrix)
GROUNDTRUTH_GAMMA0_DIRAC = spzeros(4, 4)
GROUNDTRUTH_GAMMA0_DIRAC[1, 1] = 1
GROUNDTRUTH_GAMMA0_DIRAC[2, 2] = 1
GROUNDTRUTH_GAMMA0_DIRAC[3, 3] = -1
GROUNDTRUTH_GAMMA0_DIRAC[4, 4] = -1

<<<<<<< HEAD
GROUNDTRUTH_GAMMA1_DIRAC = spzeros(4, 4)
GROUNDTRUTH_GAMMA1_DIRAC[4, 1] = -1
GROUNDTRUTH_GAMMA1_DIRAC[3, 2] = -1
GROUNDTRUTH_GAMMA1_DIRAC[2, 3] = 1
GROUNDTRUTH_GAMMA1_DIRAC[1, 4] = 1

GROUNDTRUTH_GAMMA2_DIRAC = spzeros(ComplexF64, 4, 4)
GROUNDTRUTH_GAMMA2_DIRAC[4, 1] = -1im
GROUNDTRUTH_GAMMA2_DIRAC[3, 2] = 1im
GROUNDTRUTH_GAMMA2_DIRAC[2, 3] = 1im
GROUNDTRUTH_GAMMA2_DIRAC[1, 4] = -1im

GROUNDTRUTH_GAMMA3_DIRAC = spzeros(4, 4)
GROUNDTRUTH_GAMMA3_DIRAC[3, 1] = -1
GROUNDTRUTH_GAMMA3_DIRAC[4, 2] = 1
GROUNDTRUTH_GAMMA3_DIRAC[1, 3] = 1
GROUNDTRUTH_GAMMA3_DIRAC[2, 4] = -1

=======
>>>>>>> baec5cc (Enhancement for the gitlab-ci)
@testset "gamma matrices" begin
    rng = MersenneTwister(42)

    @testset "commutator" begin
        for (i, j) in Iterators.product(1:4, 1:4)
            @test isapprox(_gamma_anticommutator(i, j), 2 * METRIC[i, j] * EYE)
        end
    end #commutator

    @testset "Minkowski product" begin
        @test GAMMA * GAMMA == 4 * one(DiracMatrix)
    end # Minkowski product

    @testset "gamma sandwich" begin
        @test SLorentzVector([_gamma_sandwich(nu) for nu in 1:4]) == -2 * GAMMA
    end # gamma sandwich

    @testset "adjoints" begin
        @test adjoint(GAMMA[1]) == GAMMA[1]
        for i in 2:4
            @test adjoint(GAMMA[i]) == -GAMMA[i]
        end

        @test SLorentzVector([adjoint(GAMMA[nu]) for nu in 1:4]) == GAMMA[1] * (GAMMA * GAMMA[1])
    end # adjoints

    @testset "interface SLorentzVector" begin
        a = SLorentzVector(rand(rng, 4))
        b = SLorentzVector(rand(rng, 4))

        a_slash = GAMMA * a
        b_slash = GAMMA * b

        @test isapprox(tr(a_slash * b_slash), 4 * a * b)
        @test isapprox(a_slash * a_slash, (a * a) * one(DiracMatrix))
        @test isapprox(GAMMA * (a_slash * GAMMA), -2 * a_slash)
    end # interface SLorentzVector

    @testset "Feynman slash" begin
        a = SLorentzVector(rand(rng, 4) + 1im * rand(rng, 4))

        @test isapprox(slashed(a), GAMMA * a)
        @test isapprox(slashed(a), slashed(DiracGammaRepresentation, a))
<<<<<<< HEAD
    end

    @testset "Dirac representation" begin
        # check the components of the gamma matrices against the 
        # Dirac representations, e.g. from https://en.wikipedia.org/wiki/Gamma_matrices
        # note: we use the convention of lower indices for the gamma matrix definition.
        #       This motivates the minus sign in front of the spatial components
        comps = 1:4
        @testset "gamma_0" begin
            @testset "($col,$row)" for (row, col) in Iterators.product(comps, comps)
                @test isapprox(GAMMA[1][row, col], GROUNDTRUTH_GAMMA0_DIRAC[row, col])
            end
        end
        @testset "gamma_1" begin
            @testset "($col,$row)" for (row, col) in Iterators.product(comps, comps)
                @test isapprox(GAMMA[2][row, col], -GROUNDTRUTH_GAMMA1_DIRAC[row, col])
            end
        end
        @testset "gamma_2" begin
            @testset "($col,$row)" for (row, col) in Iterators.product(comps, comps)
                @test isapprox(GAMMA[3][row, col], -GROUNDTRUTH_GAMMA2_DIRAC[row, col])
            end
        end
        @testset "gamma_3" begin
            @testset "($col,$row)" for (row, col) in Iterators.product(comps, comps)
                @test isapprox(GAMMA[4][row, col], -GROUNDTRUTH_GAMMA3_DIRAC[row, col])
            end
        end
=======
>>>>>>> baec5cc (Enhancement for the gitlab-ci)
    end
end

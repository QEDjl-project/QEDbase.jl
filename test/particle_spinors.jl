using QEDbase
using Random

const ATOL = 1e-15

const SPINS = (1, 2)

@testset "particle spinors" for LorentzVectorType in [SFourMomentum, MFourMomentum]
    rng = MersenneTwister(1234)
    x, y, z = rand(rng, 3)
    mass = rand(rng)
    P = LorentzVectorType(sqrt(x^2 + y^2 + z^2 + mass^2), x, y, z)

    U = SpinorU(P, mass)
    Ubar = SpinorUbar(P, mass)
    V = SpinorV(P, mass)
    Vbar = SpinorVbar(P, mass)

    @testset "construction" begin
        @test U isa IncomingFermionSpinor
        @test Ubar isa OutgoingFermionSpinor
        @test V isa OutgoingAntiFermionSpinor
        @test Vbar isa IncomingAntiFermionSpinor

        for spin in SPINS
            @test isapprox(U[spin], U.booster * BASE_PARTICLE_SPINOR[spin])
            @test isapprox(V[spin], V.booster * BASE_ANTIPARTICLE_SPINOR[spin])

            @test isapprox(Ubar[spin], AdjointBiSpinor(U[spin]) * GAMMA[1])
            @test isapprox(Vbar[spin], AdjointBiSpinor(V[spin]) * GAMMA[1])
        end
    end # construction

    @testset "normatlisation" begin
        for s1 in SPINS
            for s2 in SPINS
                @test isapprox(Ubar[s1] * U[s2], 2 * mass * (s1 == s2))
                @test isapprox(Vbar[s1] * V[s2], -2 * mass * (s1 == s2))
                @test isapprox(Ubar[s1] * V[s2], 0.0)
                @test isapprox(Vbar[s1] * U[s2], 0.0)
            end
        end
    end # normatlisation

    @testset "completeness" begin
        sumU = zero(DiracMatrix)
        sumV = zero(DiracMatrix)
        for spin in SPINS
            sumU += U(spin) * Ubar(spin)
            sumV += V(spin) * Vbar(spin)
        end

        @test isapprox(sumU, (slashed(P) + mass * one(DiracMatrix)))
        @test isapprox(sumV, (slashed(P) - mass * one(DiracMatrix)))
    end # completeness

    @testset "diracs equation" begin
        for spin in SPINS
            @test isapprox(
                (slashed(P) - mass * one(DiracMatrix)) * U[spin], zero(BiSpinor), atol=ATOL
            )
            @test isapprox(
                (slashed(P) + mass * one(DiracMatrix)) * V[spin], zero(BiSpinor), atol=ATOL
            )
            @test isapprox(
                Ubar[spin] * (slashed(P) - mass * one(DiracMatrix)),
                zero(AdjointBiSpinor),
                atol=ATOL,
            )
            @test isapprox(
                Vbar[spin] * (slashed(P) + mass * one(DiracMatrix)),
                zero(AdjointBiSpinor),
                atol=ATOL,
            )
        end
    end #diracs equation

    @testset "sandwich" begin
        for s1 in SPINS
            for s2 in SPINS
                @test isapprox(
                    LorentzVectorType(Ubar[s1] * (GAMMA * U[s2])) * (s1 == s2),
                    2 * P * (s1 == s2),
                )
            end
        end
    end #sandwich
end # particle spinors

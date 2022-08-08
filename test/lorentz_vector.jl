using StaticArrays

unary_methods = [-, +]

@testset "LorentzVectorType" for LorentzVectorType in [SLorentzVector, MLorentzVector]
    @testset "General Properties" begin
        LV = LorentzVectorType(rand(Float64, 4))

        @test size(LV) == (4,)
        @test length(LV) == 4
        @test eltype(LV) == Float64

        @test @inferred(LorentzVectorType(1, 2, 3, 4)) == LorentzVectorType([1, 2, 3, 4])

        @test LorentzVectorType(1, 2, 3, 4) == LorentzVectorType(SVector{4}(1, 2, 3, 4))

        M = rand(Float64, 4, 4)
        LV_mat = LorentzVectorType(M, M, M, M)

        @test size(LV_mat) == (4,)
        @test length(LV_mat) == 4
        @test eltype(LV_mat) == typeof(M)

        @test_throws DimensionMismatch(
            "No precise constructor for $(LorentzVectorType) found. Length of input was 2."
        ) LorentzVectorType(1, 2)

        @test LV.t == LV[1] == getT(LV)
        @test LV.x == LV[2] == getX(LV)
        @test LV.y == LV[3] == getY(LV)
        @test LV.z == LV[4] == getZ(LV)
    end # General Properties

    @testset "Arithmetics" begin
        num = 2.0
        LV1 = LorentzVectorType(1, 2, 3, 4)
        LV2 = LorentzVectorType(4, 3, 2, 1)

        @test @inferred(LV1 + LV2) == LorentzVectorType(5, 5, 5, 5)
        @test @inferred(LV1 - LV2) == LorentzVectorType(-3, -1, 1, 3)

        @test LV1 * LV2 == -12.0

        @test @inferred(num * LV1) == LorentzVectorType(2, 4, 6, 8)
        @test @inferred(LV1 * num) == LorentzVectorType(2, 4, 6, 8)
        @test @inferred(LV1 / num) == LorentzVectorType(0.5, 1.0, 1.5, 2.0)

        num_cmplx = 1.0 + 1.0im

        #maybe use @inferred for type stability check
        @test typeof(num_cmplx * LV1) === LorentzVectorType{ComplexF64} # type casting
        @test eltype(num_cmplx * LV1) === ComplexF64 # type casting
        @test typeof(LV1 * num_cmplx) === LorentzVectorType{ComplexF64} # type casting
        @test eltype(LV1 * num_cmplx) === ComplexF64 # type casting
        @test typeof(LV1 / num_cmplx) === LorentzVectorType{ComplexF64} # type casting
        @test eltype(LV1 / num_cmplx) === ComplexF64 # type casting

        LV = LorentzVectorType(rand(4))
        for ops in unary_methods
            res = ops(LV)
            @test typeof(res) == typeof(LV)
            @test SArray(res) == ops(SArray(LV))
        end
    end # Arithmetics

    @testset "interface dirac tensor" begin
        DM_eye = one(DiracMatrix)
        BS = BiSpinor(1, 2, 3, 4)
        aBS = AdjointBiSpinor(1, 2, 3, 4)

        LV_mat = LorentzVectorType(DM_eye, DM_eye, DM_eye, DM_eye)
        LV_BS = LorentzVectorType(BS, BS, BS, BS)
        LV_aBS = LorentzVectorType(aBS, aBS, aBS, aBS)

        @test @inferred(LV_mat * BS) == LV_BS
        @test @inferred(aBS * LV_mat) == LV_aBS
        @test @inferred(LV_aBS * LV_BS) == -60.0 + 0.0im
    end #interface dirac tensor

    @testset "utility functions" begin
        LV = LorentzVectorType(4, 3, 2, 1)

        @test isapprox(@inferred(getMagnitude(LV)), sqrt(14))
    end # utility functions
end # LorentzVectorType

@testset "different LorentzVectorTypes" begin
    @testset "Artihmetics" begin
        LV1 = SLorentzVector(1, 2, 3, 4)
        LV2 = MLorentzVector(4, 3, 2, 1)

        @test @inferred(LV1 + LV2) === SLorentzVector(5, 5, 5, 5)
        @test @inferred(LV1 - LV2) === SLorentzVector(-3, -1, 1, 3)

        @test LV1 * LV2 == -12.0
    end
end

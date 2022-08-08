
using StaticArrays

unary_methods = [-, +]
binary_array_methods = [+, -]
binary_float_methods = [*, /]

allowed_muls = Dict([
    (AdjointBiSpinor, BiSpinor) => ComplexF64,
    (BiSpinor, AdjointBiSpinor) => DiracMatrix,
    (AdjointBiSpinor, DiracMatrix) => AdjointBiSpinor,
    (DiracMatrix, BiSpinor) => BiSpinor,
    (DiracMatrix, DiracMatrix) => DiracMatrix,
])
<<<<<<< HEAD

groundtruth_mul(a::AdjointBiSpinor, b::BiSpinor) = transpose(SArray(a)) * SArray(b)
function groundtruth_mul(a::BiSpinor, b::AdjointBiSpinor)
    return DiracMatrix(SArray(a) * transpose(SArray(b)))
end
function groundtruth_mul(a::AdjointBiSpinor, b::DiracMatrix)
    return AdjointBiSpinor(transpose(SArray(a)) * SArray(b))
end
groundtruth_mul(a::DiracMatrix, b::BiSpinor) = BiSpinor(SArray(a) * SArray(b))
groundtruth_mul(a::DiracMatrix, b::DiracMatrix) = DiracMatrix(SArray(a) * SArray(b))
=======
>>>>>>> baec5cc (Enhancement for the gitlab-ci)

@testset "DiracTensor" begin
    dirac_tensors = [
        BiSpinor(rand(ComplexF64, 4)),
        AdjointBiSpinor(rand(ComplexF64, 4)),
        DiracMatrix(rand(ComplexF64, 4, 4)),
    ]

    @testset "BiSpinor" begin
        BS = BiSpinor(rand(4))

        @test size(BS) == (4,)
        @test length(BS) == 4
        @test eltype(BS) == ComplexF64

        @test @inferred(BiSpinor(1, 2, 3, 4)) == @inferred(BiSpinor([1, 2, 3, 4]))

        BS1 = BiSpinor(1, 2, 3, 4)
        BS2 = BiSpinor(4, 3, 2, 1)

        @test @inferred(BS1 + BS2) == BiSpinor(5, 5, 5, 5)
        @test @inferred(BS1 - BS2) == BiSpinor(-3, -1, 1, 3)

        @test_throws DimensionMismatch(
            "No precise constructor for BiSpinor found. Length of input was 2."
        ) BiSpinor(1, 2)
    end #BiSpinor

    @testset "AdjointBiSpinor" begin
        aBS = AdjointBiSpinor(rand(4))

        @test size(aBS) == (4,)
        @test length(aBS) == 4
        @test eltype(aBS) == ComplexF64

        @test @inferred(AdjointBiSpinor(1, 2, 3, 4)) ==
            @inferred(AdjointBiSpinor([1, 2, 3, 4]))

        aBS1 = AdjointBiSpinor(1, 2, 3, 4)
        aBS2 = AdjointBiSpinor(4, 3, 2, 1)

        @test @inferred(aBS1 + aBS2) == AdjointBiSpinor(5, 5, 5, 5)
        @test @inferred(aBS1 - aBS2) == AdjointBiSpinor(-3, -1, 1, 3)

        @test_throws DimensionMismatch(
            "No precise constructor for AdjointBiSpinor found. Length of input was 2."
        ) AdjointBiSpinor(1, 2)
    end #AdjointBiSpinor

    @testset "DiracMatrix" begin
        DM = DiracMatrix(rand(4, 4))

        @test size(DM) == (4, 4)
        @test length(DM) == 16
        @test eltype(DM) == ComplexF64

        DM1 = DiracMatrix(SDiagonal(1, 2, 3, 4))
        DM2 = DiracMatrix(SDiagonal(4, 3, 2, 1))

        @test @inferred(DM1 + DM2) == DiracMatrix(SDiagonal(5, 5, 5, 5))
        @test @inferred(DM1 - DM2) == DiracMatrix(SDiagonal(-3, -1, 1, 3))

        @test_throws DimensionMismatch(
            "No precise constructor for DiracMatrix found. Length of input was 2."
        ) DiracMatrix(1, 2)
    end #DiracMatrix

    @testset "General Arithmetics" begin
        num = rand(ComplexF64)

        for ten in dirac_tensors
            @testset "$ops($(typeof(ten)))" for ops in unary_methods
                res = ops(ten)
                @test typeof(res) == typeof(ten)
                @test SArray(res) == ops(SArray(ten))
            end

<<<<<<< HEAD
            @testset "num*$(typeof(ten))" begin
                #@test typeof(res_float_mul) == typeof(ten)
                @test @inferred(ten * num) == @inferred(num * ten)
                @test SArray(num * ten) == num * SArray(ten)
            end

            @testset "$(typeof(ten))/num" begin
                res_float_div = ten / num
                #@test typeof(res_float_div) == typeof(ten)
                @test SArray(@inferred(ten / num)) == SArray(ten) / num
            end

            @testset "$(typeof(ten))*$(typeof(ten2))" for ten2 in dirac_tensors
=======
            #@test typeof(res_float_mul) == typeof(ten)
            @test @inferred(ten * num) == @inferred(num * ten)
            @test SArray(num * ten) == num * SArray(ten)

            res_float_div = ten / num
            #@test typeof(res_float_div) == typeof(ten)
            @test SArray(@inferred(ten / num)) == SArray(ten) / num

            for ten2 in dirac_tensors
>>>>>>> baec5cc (Enhancement for the gitlab-ci)
                mul_comb = (typeof(ten), typeof(ten2))
                if mul_comb in keys(allowed_muls)
                    res = ten * ten2
                    @test typeof(res) == allowed_muls[mul_comb]
                    @test isapprox(res, groundtruth_mul(ten, ten2))
                    #issue: test raise of method error
                end
            end
        end
    end #Arithmetics
end #"DiracTensor"

using StaticArrays

unary_methods = [-,+]

@testset "LorentzVector" begin

    @testset "General Properties" begin
        LV = LorentzVector(rand(Float64,4))

        @test size(LV) == (4,)
        @test length(LV) == 4
        @test eltype(LV) == Float64

        @test @inferred(LorentzVector(1,2,3,4)) ==  LorentzVector([1,2,3,4])

        @test LorentzVector(1,2,3,4) ==  LorentzVector(SVector{4}(1,2,3,4))

        M = rand(Float64,4,4)
        LV_mat = LorentzVector(M,M,M,M)

        @test size(LV_mat) == (4,)
        @test length(LV_mat) == 4
        @test eltype(LV_mat) == typeof(M)

        @test_throws DimensionMismatch("No precise constructor for LorentzVector found. Length of input was 2.") LorentzVector(1,2)

        @test LV.t == LV[1]
        @test LV.x == LV[2]
        @test LV.y == LV[3]
        @test LV.z == LV[4]

    end # General Properties

    @testset "Arithmetics" begin
        num = 2.0
        LV1 = LorentzVector(1,2,3,4)
        LV2 = LorentzVector(4,3,2,1)

        @test @inferred(LV1 + LV2) == LorentzVector(5,5,5,5)
        @test @inferred(LV1 - LV2) == LorentzVector(-3,-1,1,3)

        @test LV1*LV2 == -12.0

        @test @inferred(num*LV1) == LorentzVector(2,4,6,8)
        @test @inferred(LV1*num) == LorentzVector(2,4,6,8)
        @test @inferred(LV1/num) == LorentzVector(0.5,1.0,1.5,2.0)

        num_cmplx = 1.0+1.0im

        #maybe use @inferred for type stability check
        @test typeof(num_cmplx*LV1)==LorentzVector{ComplexF64} # type casting
        @test eltype(num_cmplx*LV1)==ComplexF64 # type casting
        @test typeof(LV1*num_cmplx)==LorentzVector{ComplexF64} # type casting
        @test eltype(LV1*num_cmplx)==ComplexF64 # type casting
        @test typeof(LV1/num_cmplx)==LorentzVector{ComplexF64} # type casting
        @test eltype(LV1/num_cmplx)==ComplexF64 # type casting

        LV = LorentzVector(rand(4))
        for ops in unary_methods
            res = ops(LV)
            @test typeof(res) == typeof(LV)
            @test SArray(res) == ops(SArray(LV))
        end
    end # Arithmetics

    @testset "interface dirac tensor" begin
        DM_eye = one(DiracMatrix)
        BS = BiSpinor(1,2,3,4)
        aBS = AdjointBiSpinor(1,2,3,4)

        LV_mat = LorentzVector(DM_eye,DM_eye,DM_eye,DM_eye)
        LV_BS  = LorentzVector(BS,BS,BS,BS)
        LV_aBS  = LorentzVector(aBS,aBS,aBS,aBS)

        @test @inferred(LV_mat*BS) == LV_BS
        @test @inferred(aBS*LV_mat) == LV_aBS
        @test @inferred(LV_aBS*LV_BS) == -60.0 + 0.0im

    end #interface dirac tensor

    @testset "utility functions" begin
        v = SVector{4}(4,3,2,1)
        LV = LorentzVector(v)

        @test isapprox(@inferred(magnitude(LV)),sqrt(2))

    end # utility functions

end # LorentzVector

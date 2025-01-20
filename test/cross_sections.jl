using Random
using QEDbase

RNG = MersenneTwister(137137)

include("test_implementation/TestImplementation.jl")
using .TestImplementation

TESTMODEL = TestModel()
TESTMODEL_FAIL = TestImplementation.TestModel_FAIL()
TESTPSDEF_FAIL = TestImplementation.TestPhasespaceDef_FAIL()

@testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in Iterators.product(
    (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
)
    INCOMING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_INCOMING))
    OUTGOING_PARTICLES = Tuple(rand(RNG, TestImplementation.PARTICLE_SET, N_OUTGOING))

    TESTPROC = TestProcess(INCOMING_PARTICLES, OUTGOING_PARTICLES)

    TESTPROC_FAIL_DIFFCS = TestImplementation.TestProcess_FAIL_DIFFCS(
        INCOMING_PARTICLES, OUTGOING_PARTICLES
    )

    # Float 16 runs quickly into infs
    @testset "$MOM_EL_TYPE" for MOM_EL_TYPE in (Float32, Float64)
        MOM_TYPE = TestMomentum{MOM_EL_TYPE}
        ATOL = 0.0
        RTOL = sqrt(eps(MOM_EL_TYPE))

        TESTPSDEF = TestPhasespaceDef{MOM_TYPE}()
        # single ps points
        p_in_phys = TestImplementation._rand_momenta(RNG, N_INCOMING, MOM_TYPE)
        p_in_phys_invalid = TestImplementation._rand_momenta(RNG, N_INCOMING + 1, MOM_TYPE)
        p_in_unphys = TestImplementation._rand_in_momenta_failing(RNG, N_INCOMING, MOM_TYPE)

        p_out_phys = TestImplementation._rand_momenta(RNG, N_OUTGOING, MOM_TYPE)
        p_out_unphys = TestImplementation._rand_out_momenta_failing(
            RNG, N_OUTGOING, MOM_TYPE
        )

        p_in_all = (p_in_phys, p_in_unphys)

        p_out_all = (p_out_phys, p_out_unphys)

        # all combinations
        p_combs = Iterators.product(p_in_all, p_out_all)

        @testset "interface" begin
            @testset "incident flux" begin
                test_incident_flux = QEDbase._incident_flux(
                    TestInPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys)
                )
                groundtruth = TestImplementation._groundtruth_incident_flux(p_in_phys)
                @test isapprox(test_incident_flux, groundtruth, atol=ATOL, rtol=RTOL)

                test_incident_flux = QEDbase._incident_flux(
                    TestPhaseSpacePoint(
                        TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
                    ),
                )
                @test test_incident_flux isa MOM_EL_TYPE
                @test isapprox(test_incident_flux, groundtruth, atol=ATOL, rtol=RTOL)

                #@test_throws MethodError QEDbase._incident_flux(
                #    OutPhaseSpacePoint(TESTPROC, TESTMODEL, TESTPSDEF, OUT_PS)
                #)
            end

            @testset "averaging norm" begin
                test_avg_norm = QEDbase._averaging_norm(TESTPROC)
                groundtruth = TestImplementation._groundtruth_averaging_norm(TESTPROC)
                @test isapprox(test_avg_norm, groundtruth, atol=ATOL, rtol=RTOL)
            end

            @testset "matrix element" begin
                test_matrix_element = QEDbase._matrix_element(
                    TestPhaseSpacePoint(
                        TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
                    ),
                )
                groundtruth = TestImplementation._groundtruth_matrix_element(
                    p_in_phys, p_out_phys
                )
                @test length(test_matrix_element) == length(groundtruth)
                for i in eachindex(test_matrix_element)
                    @test test_matrix_element[i] isa Complex{MOM_EL_TYPE}
                    @test isapprox(
                        test_matrix_element[i], groundtruth[i], atol=ATOL, rtol=RTOL
                    )
                end
            end

            @testset "is in phasespace" begin
                @test @inferred QEDbase._is_in_phasespace(
                    TestPhaseSpacePoint(
                        TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
                    ),
                )

                PSP_unphysical_in_ps = TestPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_unphys, p_out_phys
                )
                PSP_unphysical_out_ps = TestPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_unphys
                )
                PSP_unphysical = TestPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_unphys, p_out_unphys
                )

                @test !QEDbase._is_in_phasespace(PSP_unphysical_in_ps)
                @test !QEDbase._is_in_phasespace(PSP_unphysical_out_ps)
                @test !QEDbase._is_in_phasespace(PSP_unphysical)
            end

            @testset "phase space factor" begin
                test_phase_space_factor = QEDbase._phase_space_factor(
                    TestPhaseSpacePoint(
                        TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
                    ),
                )
                groundtruth = TestImplementation._groundtruth_phase_space_factor(
                    p_in_phys, p_out_phys
                )
                @test test_phase_space_factor isa MOM_EL_TYPE
                @test isapprox(test_phase_space_factor, groundtruth, atol=ATOL, rtol=RTOL)
            end
        end

        @testset "differential cross section" begin
            @testset "unsafe compute" begin
                PS_POINT = TestPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
                )

                diffCS_on_psp = unsafe_differential_cross_section(PS_POINT)
                groundtruth = TestImplementation._groundtruth_unsafe_diffCS(
                    TESTPROC, p_in_phys, p_out_phys
                )

                # This test is broken for MOM_EL_TYPE==Float32 (see https://github.com/QEDjl-project/QEDbase.jl/issues/147)
                # @test diffCS_on_psp isa MOM_EL_TYPE
                @test isapprox(diffCS_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
            end

            @testset "safe compute" begin
                for (P_IN, P_OUT) in p_combs
                    PS_POINT = TestPhaseSpacePoint(
                        TESTPROC, TESTMODEL, TESTPSDEF, P_IN, P_OUT
                    )

                    diffCS_on_psp = differential_cross_section(PS_POINT)
                    groundtruth = TestImplementation._groundtruth_safe_diffCS(
                        TESTPROC, P_IN, P_OUT
                    )

                    # This test is broken for MOM_EL_TYPE==Float32 (see https://github.com/QEDjl-project/QEDbase.jl/issues/147)
                    # @test diffCS_on_psp isa MOM_EL_TYPE
                    @test isapprox(diffCS_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
                end
            end

            @testset "failed" begin
                @testset "$PROC $MODEL" for (PROC, MODEL) in Iterators.product(
                    (TESTPROC, TESTPROC_FAIL_DIFFCS), (TESTMODEL, TESTMODEL_FAIL)
                )
                    if TestImplementation._any_fail(PROC, MODEL)
                        for (P_IN, P_OUT) in p_combs
                            psp = TestPhaseSpacePoint(PROC, MODEL, TESTPSDEF, P_IN, P_OUT)
                            @test_throws MethodError QEDbase._incident_flux(psp)
                            @test_throws MethodError QEDbase._averaging_norm(psp)
                            @test_throws MethodError QEDbase._matrix_element(psp)
                        end
                    end

                    for PS_DEF in (TESTPSDEF, TESTPSDEF_FAIL)
                        if TestImplementation._any_fail(PROC, MODEL, PS_DEF)
                            for (P_IN, P_OUT) in p_combs
                                psp = TestPhaseSpacePoint(PROC, MODEL, PS_DEF, P_IN, P_OUT)
                                @test_throws MethodError QEDbase._phase_space_factor(psp)
                            end
                        end
                    end
                end
            end
        end

        @testset "total cross section" begin
            @testset "compute" begin
                IN_PS_POINT = TestInPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys
                )

                groundtruth = TestImplementation._groundtruth_total_cross_section(p_in_phys)
                totCS_on_moms = total_cross_section(IN_PS_POINT)

                @test totCS_on_moms isa MOM_EL_TYPE
                @test isapprox(totCS_on_moms, groundtruth, atol=ATOL, rtol=RTOL)
            end
        end

        @testset "differential probability" begin
            @testset "unsafe compute" begin
                PS_POINT = TestPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys, p_out_phys
                )
                prop_on_psp = unsafe_differential_probability(PS_POINT)
                groundtruth = TestImplementation._groundtruth_unsafe_probability(
                    TESTPROC, p_in_phys, p_out_phys
                )

                # This test is broken for MOM_EL_TYPE==Float32 (see https://github.com/QEDjl-project/QEDbase.jl/issues/147)
                # @test prop_on_psp isa MOM_EL_TYPE
                @test isapprox(prop_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
            end

            @testset "safe compute" begin
                for (P_IN, P_OUT) in p_combs
                    PS_POINT = TestPhaseSpacePoint(
                        TESTPROC, TESTMODEL, TESTPSDEF, P_IN, P_OUT
                    )
                    prop_on_psp = differential_probability(PS_POINT)
                    groundtruth = TestImplementation._groundtruth_safe_probability(
                        TESTPROC, P_IN, P_OUT
                    )
                    # This test is broken for MOM_EL_TYPE==Float32 (see https://github.com/QEDjl-project/QEDbase.jl/issues/147)
                    # @test prop_on_psp isa MOM_EL_TYPE
                    @test isapprox(prop_on_psp, groundtruth, atol=ATOL, rtol=RTOL)
                end
            end
        end

        @testset "total probability" begin
            @testset "compute" begin
                IN_PS_POINT = TestInPhaseSpacePoint(
                    TESTPROC, TESTMODEL, TESTPSDEF, p_in_phys
                )

                groundtruth = TestImplementation._groundtruth_total_probability(p_in_phys)
                tot_prop_on_moms = TestImplementation.total_probability(IN_PS_POINT)

                @test tot_prop_on_moms isa MOM_EL_TYPE
                @test isapprox(tot_prop_on_moms, groundtruth, atol=ATOL, rtol=RTOL)
            end
        end
    end
end

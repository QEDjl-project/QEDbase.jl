using Random
using Suppressor
using QEDbase

RNG = MersenneTwister(137137)
ATOL = 0.0
RTOL = sqrt(eps())

_groundtruth_compute(x) = x
_groundtruth_input_validation(x) = (x > 0)
struct TestException <: QEDbase.AbstractInvalidInputException end
function _groundtruth_valid_input_assert(x)
    _groundtruth_input_validation(x) || throw(TestException())
    return nothing
end
_transform_to_invalid(x) = -abs(x)
_groundtruth_post_processing(x, y) = x + y

# setups for which the interface is implemented
abstract type AbstractTestSetup <: AbstractComputationSetup end
QEDbase._compute(stp::AbstractTestSetup, x) = _groundtruth_compute(x)

# setup with default implementations
struct TestSetupDefault <: AbstractTestSetup end

# setup with custom _assert_valid_input 
struct TestSetupCustomAssertValidInput <: AbstractTestSetup end
function QEDbase._assert_valid_input(stp::TestSetupCustomAssertValidInput, x)
    return _groundtruth_valid_input_assert(x)
end

# setup with custom post processing 
struct TestSetupCustomPostProcessing <: AbstractTestSetup end
function QEDbase._post_processing(::TestSetupCustomPostProcessing, x, y)
    return _groundtruth_post_processing(x, y)
end

# setup with custom input validation and post processing 
struct TestSetupCustom <: AbstractTestSetup end
function QEDbase._assert_valid_input(stp::TestSetupCustom, x)
    return _groundtruth_valid_input_assert(x)
end
QEDbase._post_processing(::TestSetupCustom, x, y) = _groundtruth_post_processing(x, y)

# setup which fail on computation with default implementations
struct TestSetupFAIL <: AbstractComputationSetup end

# setup which fail on computation with custom input validation, where the
# invalid input will be caught before the computation.
struct TestSetupCustomValidationFAIL <: AbstractComputationSetup end
function QEDbase._assert_valid_input(stp::TestSetupCustomValidationFAIL, x)
    return _groundtruth_valid_input_assert(x)
end

# setup which fail on computation with custom post processing
struct TestSetupCustomPostProcessingFAIL <: AbstractComputationSetup end
function QEDbase._post_processing(::TestSetupCustomPostProcessingFAIL, x, y)
    return _groundtruth_post_processing(x, y)
end
@testset "general computation setup interface" begin
    @testset "interface fail" begin
        rnd_input = rand(RNG)

        @test_throws MethodError QEDbase._compute(TestSetupFAIL(), rnd_input)
        @test_throws MethodError compute(TestSetupFAIL(), rnd_input)

        @test_throws MethodError QEDbase._compute(
            TestSetupCustomValidationFAIL(), rnd_input
        )
        @test_throws MethodError compute(TestSetupCustomValidationFAIL(), rnd_input)
        # invalid input should be caught without throwing a MethodError
        @test_throws TestException compute(
            TestSetupCustomValidationFAIL(), _transform_to_invalid(rnd_input)
        )

        @test_throws MethodError QEDbase._compute(
            TestSetupCustomPostProcessingFAIL(), rnd_input
        )
        @test_throws MethodError compute(TestSetupCustomPostProcessingFAIL(), rnd_input)
    end

    @testset "default interface" begin
        stp = TestSetupDefault()

        rnd_input = rand(RNG)
        rnd_output = rand(RNG)
        @test QEDbase._post_processing(stp, rnd_input, rnd_output) == rnd_output
        @test isapprox(
            QEDbase._compute(stp, rnd_input),
            _groundtruth_compute(rnd_input),
            atol=ATOL,
            rtol=RTOL,
        )
        @test isapprox(
            compute(stp, rnd_input), _groundtruth_compute(rnd_input), atol=ATOL, rtol=RTOL
        )
    end

    @testset "custom input validation" begin
        stp = TestSetupCustomAssertValidInput()
        rnd_input = rand(RNG)
        @test QEDbase._assert_valid_input(stp, rnd_input) == nothing
        @test_throws TestException QEDbase._assert_valid_input(
            stp, _transform_to_invalid(rnd_input)
        )
        @test_throws TestException compute(stp, _transform_to_invalid(rnd_input))
    end

    @testset "custom post processing" begin
        stp = TestSetupCustomPostProcessing()
        rnd_input = rand(RNG)
        rnd_output = rand(RNG)
        @test isapprox(
            QEDbase._post_processing(stp, rnd_input, rnd_output),
            _groundtruth_post_processing(rnd_input, rnd_output),
        )
        @test isapprox(
            compute(stp, rnd_input),
            _groundtruth_post_processing(rnd_input, _groundtruth_compute(rnd_input)),
        )
    end

    @testset "custom input validation and post processing" begin
        stp = TestSetupCustom()
        rnd_input = rand(RNG)
        rnd_output = rand(RNG)

        @test_throws TestException() compute(stp, _transform_to_invalid(rnd_input))
        @test isapprox(
            QEDbase._post_processing(stp, rnd_input, rnd_output),
            _groundtruth_post_processing(rnd_input, rnd_output),
        )
        @test isapprox(
            compute(stp, rnd_input),
            _groundtruth_post_processing(rnd_input, _groundtruth_compute(rnd_input)),
        )
    end
end
# process setup 

struct TestParticle1 <: AbstractParticle end
struct TestParticle2 <: AbstractParticle end
struct TestParticle3 <: AbstractParticle end
struct TestParticle4 <: AbstractParticle end

PARTICLE_SET = [TestParticle1(), TestParticle2(), TestParticle3(), TestParticle4()]

struct TestProcess <: AbstractProcessDefinition end
struct TestModel <: AbstractModelDefinition end

struct TestProcessSetup <: AbstractProcessSetup end
QEDbase.scattering_process(::TestProcessSetup) = TestProcess()
QEDbase.physical_model(::TestProcessSetup) = TestModel()

struct TestProcessSetupFAIL <: AbstractProcessSetup end

@testset "process setup interface" begin
    @testset "interface fail" begin
        rnd_input = rand(RNG)
        @test_throws MethodError scattering_process(TestProcessSetupFAIL())
        @test_throws MethodError physical_model(TestProcessSetupFAIL())
        @test_throws MethodError QEDbase._compute(TestProcessSetupFAIL(), rnd_input)
    end

    @testset "hard interface" begin
        stp = TestProcessSetup()

        @test QEDbase._is_computation_setup(stp)
        @test scattering_process(stp) == TestProcess()
        @test physical_model(stp) == TestModel()
    end

    @testset "($N_INCOMING,$N_OUTGOING)" for (N_INCOMING, N_OUTGOING) in Iterators.product(
        (1, rand(RNG, 2:8)), (1, rand(RNG, 2:8))
    )
        INCOMING_PARTICLES = rand(RNG, PARTICLE_SET, N_INCOMING)
        OUTGOING_PARTICLES = rand(RNG, PARTICLE_SET, N_OUTGOING)

        @suppress QEDbase.incoming_particles(::TestProcess) = INCOMING_PARTICLES
        @suppress QEDbase.outgoing_particles(::TestProcess) = OUTGOING_PARTICLES

        @testset "delegated functions" begin
            stp = TestProcessSetup()
            @test number_incoming_particles(stp) == N_INCOMING
            @test number_outgoing_particles(stp) == N_OUTGOING
        end
    end
end

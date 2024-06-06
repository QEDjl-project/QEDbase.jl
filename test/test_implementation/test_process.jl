# dummy particles
struct TestParticleFermion <: FermionLike end
struct TestParticleBoson <: BosonLike end

const PARTICLE_SET = [TestParticleFermion(), TestParticleBoson()]

"""
    TestProcess(rng,incoming_particles,outgoing_particles)

"""
struct TestProcess{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function TestProcess(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = rand(rng, PARTICLE_SET, N_in)
    out_particles = rand(rng, PARTICLE_SET, N_out)
    return TestProcess(in_particles, out_particles)
end

QEDbase.incoming_particles(proc::TestProcess) = proc.incoming_particles
QEDbase.outgoing_particles(proc::TestProcess) = proc.outgoing_particles

struct TestProcess_FAIL{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function TestProcess_FAIL(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return TestProcess_FAIL(in_particles, out_particles)
end

function QEDbase.in_phase_space_dimension(proc::TestProcess, ::TestModel)
    return number_incoming_particles(proc) * 4
end
function QEDbase.out_phase_space_dimension(proc::TestProcess, ::TestModel)
    return number_outgoing_particles(proc) * 4
end

"""
Test process with no implemented interface. Should fail every usage except construction.
"""
struct TestProcess_FAIL_ALL{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function TestProcess_FAIL_ALL(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return TestProcess_FAIL_ALL(in_particles, out_particles)
end

"""
Test process with no implemented interface except the incoming and outgoing particles. 
Should fail every usage except construction of itself and the respective phase space point for given four-momenta.
"""
struct TestProcess_FAIL_DIFFCS{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function TestProcess_FAIL_DIFFCS(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return TestProcess_FAIL_DIFFCS(in_particles, out_particles)
end

QEDbase.incoming_particles(proc::TestProcess_FAIL_DIFFCS) = proc.incoming_particles
QEDbase.outgoing_particles(proc::TestProcess_FAIL_DIFFCS) = proc.outgoing_particles

# dummy phase space definition + failing phase space definition
struct TestPhasespaceDef <: AbstractPhasespaceDefinition end
struct TestPhasespaceDef_FAIL <: AbstractPhasespaceDefinition end

# dummy implementation of the process interface

function QEDbase._incident_flux(in_psp::InPhaseSpacePoint{<:TestProcess,<:TestModel})
    return _groundtruth_incident_flux(momenta(in_psp, Incoming()))
end

function QEDbase._averaging_norm(proc::TestProcess)
    return _groundtruth_averaging_norm(proc)
end

function QEDbase._matrix_element(psp::PhaseSpacePoint{<:TestProcess,TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_matrix_element(in_ps, out_ps)
end

function QEDbase._is_in_phasespace(psp::PhaseSpacePoint{<:TestProcess,TestModel})
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_is_in_phasespace(in_ps, out_ps)
end

function QEDbase._phase_space_factor(
    psp::PhaseSpacePoint{<:TestProcess,TestModel,TestPhasespaceDef}
)
    in_ps = momenta(psp, Incoming())
    out_ps = momenta(psp, Outgoing())
    return _groundtruth_phase_space_factor(in_ps, out_ps)
end

function QEDbase._generate_incoming_momenta(
    proc::TestProcess,
    model::TestModel,
    phase_space_def::TestPhasespaceDef,
    in_phase_space::NTuple{N,T},
) where {N,T<:Real}
    return _groundtruth_generate_momenta(in_phase_space)
end

function QEDbase._generate_outgoing_momenta(
    proc::TestProcess,
    model::TestModel,
    phase_space_def::TestPhasespaceDef,
    out_phase_space::NTuple{N,T},
) where {N,T<:Real}
    return _groundtruth_generate_momenta(out_phase_space)
end

function QEDbase._total_probability(
    in_psp::InPhaseSpacePoint{<:TestProcess,<:TestModel,<:TestPhasespaceDef}
)
    return _groundtruth_total_probability(momenta(in_psp, Incoming()))
end

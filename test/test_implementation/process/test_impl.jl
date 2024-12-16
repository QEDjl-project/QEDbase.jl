"""
    TestProcess(rng,incoming_particles,outgoing_particles)

"""
struct TestProcess{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function TestProcess(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return TestProcess(in_particles, out_particles)
end

QEDbase.incoming_particles(proc::TestProcess) = proc.incoming_particles
QEDbase.outgoing_particles(proc::TestProcess) = proc.outgoing_particles

function QEDbase.in_phase_space_dimension(proc::TestProcess, ::TestModel)
    return _groundtruth_in_ps_dim(proc)
end
function QEDbase.out_phase_space_dimension(proc::TestProcess, ::TestModel)
    return _groundtruth_out_ps_dim(proc)
end

"""
    TestProcessSP

Process for testing with settable spin and polarization.
"""
struct TestProcessSP{IP<:Tuple,OP<:Tuple,IN_SP<:Tuple,OUT_SP<:Tuple} <:
       AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
    incoming_spin_pols::IN_SP
    outgoing_spin_pols::OUT_SP
end

QEDbase.incoming_particles(proc::TestProcessSP) = proc.incoming_particles
QEDbase.outgoing_particles(proc::TestProcessSP) = proc.outgoing_particles
QEDbase.incoming_spin_pols(proc::TestProcessSP) = proc.incoming_spin_pols
QEDbase.outgoing_spin_pols(proc::TestProcessSP) = proc.outgoing_spin_pols

# Failing processes

struct TestProcess_FAIL{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function TestProcess_FAIL(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return TestProcess_FAIL(in_particles, out_particles)
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

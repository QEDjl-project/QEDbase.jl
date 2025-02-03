"""
    MockProcess(rng,incoming_particles,outgoing_particles)

"""
struct MockProcess{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function MockProcess(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return MockProcess(in_particles, out_particles)
end

QEDbase.incoming_particles(proc::MockProcess) = proc.incoming_particles
QEDbase.outgoing_particles(proc::MockProcess) = proc.outgoing_particles

function QEDbase.in_phase_space_dimension(proc::MockProcess, ::MockModel)
    return _groundtruth_in_ps_dim(proc)
end
function QEDbase.out_phase_space_dimension(proc::MockProcess, ::MockModel)
    return _groundtruth_out_ps_dim(proc)
end

function Base.show(io::IO, proc::MockProcess)
    N = number_incoming_particles(proc)
    M = number_outgoing_particles(proc)
    print(io, "mock process ($N -> $M)")
    return nothing
end

"""
    MockProcessSP

Process for testing with settable spin and polarization.
"""
struct MockProcessSP{IP<:Tuple,OP<:Tuple,IN_SP<:Tuple,OUT_SP<:Tuple} <:
       AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
    incoming_spin_pols::IN_SP
    outgoing_spin_pols::OUT_SP
end

QEDbase.incoming_particles(proc::MockProcessSP) = proc.incoming_particles
QEDbase.outgoing_particles(proc::MockProcessSP) = proc.outgoing_particles
QEDbase.incoming_spin_pols(proc::MockProcessSP) = proc.incoming_spin_pols
QEDbase.outgoing_spin_pols(proc::MockProcessSP) = proc.outgoing_spin_pols

# Failing processes

struct MockProcess_FAIL{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function MockProcess_FAIL(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return MockProcess_FAIL(in_particles, out_particles)
end

"""
Mock process with no implemented interface. Should fail every usage except construction.
"""
struct MockProcess_FAIL_ALL{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function MockProcess_FAIL_ALL(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return MockProcess_FAIL_ALL(in_particles, out_particles)
end

"""
Mock process with no implemented interface except the incoming and outgoing particles.
Should fail every usage except construction of itself and the respective phase space point for given four-momenta.
"""
struct MockProcess_FAIL_DIFFCS{IP<:Tuple,OP<:Tuple} <: AbstractProcessDefinition
    incoming_particles::IP
    outgoing_particles::OP
end

function MockProcess_FAIL_DIFFCS(rng::AbstractRNG, N_in::Int, N_out::Int)
    in_particles = Tuple(rand(rng, PARTICLE_SET, N_in))
    out_particles = Tuple(rand(rng, PARTICLE_SET, N_out))
    return MockProcess_FAIL_DIFFCS(in_particles, out_particles)
end

QEDbase.incoming_particles(proc::MockProcess_FAIL_DIFFCS) = proc.incoming_particles
QEDbase.outgoing_particles(proc::MockProcess_FAIL_DIFFCS) = proc.outgoing_particles

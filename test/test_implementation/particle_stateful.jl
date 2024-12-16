
struct TestParticleStateful{D,P,M} <: AbstractParticleStateful{D,P,M}
    dir::D
    part::P
    mom::M
end

QEDbase.particle_direction(ps::TestParticleStateful) = ps.dir
QEDbase.particle_species(ps::TestParticleStateful) = ps.part
QEDbase.momentum(ps::TestParticleStateful) = ps.mom

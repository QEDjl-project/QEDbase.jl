
struct MockParticleStateful{D,P,M} <: AbstractParticleStateful{D,P,M}
    dir::D
    part::P
    mom::M
end

QEDbase.particle_direction(ps::MockParticleStateful) = ps.dir
QEDbase.particle_species(ps::MockParticleStateful) = ps.part
QEDbase.momentum(ps::MockParticleStateful) = ps.mom

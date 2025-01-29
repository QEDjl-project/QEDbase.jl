# dummy particles
struct MockFermion <: AbstractParticleType end
QEDbase.is_fermion(::MockFermion) = true
QEDbase.is_boson(::MockFermion) = false
QEDbase.is_particle(::MockFermion) = true
QEDbase.is_anti_particle(::MockFermion) = false
QEDbase.mass(::MockFermion) = _MASS_TEST_FERMION
QEDbase.charge(::MockFermion) = _CHARGE_TEST_FERMION
function QEDbase.propagator(::MockFermion, mom::AbstractMockMomentum)
    return _groundtruth_fermion_propagator(mom)
end
function QEDbase.base_state(
    ::MockFermion,
    dir::ParticleDirection,
    mom::AbstractMockMomentum,
    spin::AbstractSpinOrPolarization,
)
    return _groundtruth_fermion_base_state(dir, mom, spin)
end

struct MockMasslessFermion <: AbstractParticleType end
QEDbase.is_fermion(::MockMasslessFermion) = true
QEDbase.is_boson(::MockMasslessFermion) = false
QEDbase.is_particle(::MockMasslessFermion) = true
QEDbase.is_anti_particle(::MockMasslessFermion) = false
QEDbase.mass(::MockMasslessFermion) = 0.0
QEDbase.charge(::MockMasslessFermion) = _CHARGE_TEST_FERMION
function QEDbase.propagator(::MockMasslessFermion, mom::AbstractMockMomentum)
    return _groundtruth_fermion_propagator(mom)
end
function QEDbase.base_state(
    ::MockMasslessFermion,
    dir::ParticleDirection,
    mom::AbstractMockMomentum,
    spin::AbstractSpinOrPolarization,
)
    return _groundtruth_massless_fermion_base_state(dir, mom, spin)
end

struct MockBoson <: AbstractParticleType end
QEDbase.is_fermion(::MockBoson) = false
QEDbase.is_boson(::MockBoson) = true
QEDbase.is_particle(::MockBoson) = true
QEDbase.is_anti_particle(::MockBoson) = false
QEDbase.mass(::MockBoson) = _MASS_TEST_BOSON
QEDbase.charge(::MockBoson) = _CHARGE_TEST_BOSON
function QEDbase.propagator(::MockBoson, mom::AbstractMockMomentum)
    return _groundtruth_boson_propagator(mom)
end
function QEDbase.base_state(
    ::MockBoson,
    dir::ParticleDirection,
    mom::AbstractMockMomentum,
    pol::AbstractSpinOrPolarization,
)
    return _groundtruth_boson_base_state(dir, mom, pol)
end

struct MockMasslessBoson <: AbstractParticleType end
QEDbase.is_fermion(::MockMasslessBoson) = false
QEDbase.is_boson(::MockMasslessBoson) = true
QEDbase.is_particle(::MockMasslessBoson) = true
QEDbase.is_anti_particle(::MockMasslessBoson) = false
QEDbase.mass(::MockMasslessBoson) = 0.0
QEDbase.charge(::MockMasslessBoson) = _CHARGE_TEST_BOSON
function QEDbase.propagator(::MockMasslessBoson, mom::AbstractMockMomentum)
    return _groundtruth_boson_propagator(mom)
end
function QEDbase.base_state(
    ::MockMasslessBoson,
    dir::ParticleDirection,
    mom::AbstractMockMomentum,
    pol::AbstractSpinOrPolarization,
)
    return _groundtruth_massless_boson_base_state(dir, mom, pol)
end

const PARTICLE_SET = [
    MockFermion(), MockMasslessFermion(), MockBoson(), MockMasslessBoson()
]

#TODO: add massless versions

# dummy particles
struct TestFermion <: AbstractParticleType end
QEDbase.is_fermion(::TestFermion) = true
QEDbase.is_boson(::TestFermion) = false
QEDbase.is_particle(::TestFermion) = true
QEDbase.is_anti_particle(::TestFermion) = false
QEDbase.mass(::TestFermion) = _MASS_TEST_FERMION
QEDbase.charge(::TestFermion) = _CHARGE_TEST_FERMION

struct TestBoson <: AbstractParticleType end
QEDbase.is_fermion(::TestBoson) = true
QEDbase.is_boson(::TestBoson) = false
QEDbase.is_particle(::TestBoson) = true
QEDbase.is_anti_particle(::TestBoson) = false
QEDbase.mass(::TestBoson) = _MASS_TEST_BOSON
QEDbase.charge(::TestBoson) = _CHARGE_TEST_BOSON

const PARTICLE_SET = [TestFermion(), TestBoson()]

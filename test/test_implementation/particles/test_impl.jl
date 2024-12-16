#TODO: add massless versions

# dummy particles
struct TestFermion <: AbstractParticleType end
QEDbase.is_fermion(::TestFermion) = true
QEDbase.is_boson(::TestFermion) = false
QEDbase.is_particle(::TestFermion) = true
QEDbase.is_anti_particle(::TestFermion) = false
QEDbase.mass(::TestFermion) = _MASS_TEST_FERMION
QEDbase.charge(::TestFermion) = _CHARGE_TEST_FERMION

struct TestMasslessFermion <: AbstractParticleType end
QEDbase.is_fermion(::TestMasslessFermion) = true
QEDbase.is_boson(::TestMasslessFermion) = false
QEDbase.is_particle(::TestMasslessFermion) = true
QEDbase.is_anti_particle(::TestMasslessFermion) = false
QEDbase.mass(::TestMasslessFermion) = 0.0
QEDbase.charge(::TestMasslessFermion) = _CHARGE_TEST_FERMION

struct TestBoson <: AbstractParticleType end
QEDbase.is_fermion(::TestBoson) = true
QEDbase.is_boson(::TestBoson) = false
QEDbase.is_particle(::TestBoson) = true
QEDbase.is_anti_particle(::TestBoson) = false
QEDbase.mass(::TestBoson) = _MASS_TEST_BOSON
QEDbase.charge(::TestBoson) = _CHARGE_TEST_BOSON

struct TestMasslessBoson <: AbstractParticleType end
QEDbase.is_fermion(::TestMasslessBoson) = true
QEDbase.is_boson(::TestMasslessBoson) = false
QEDbase.is_particle(::TestMasslessBoson) = true
QEDbase.is_anti_particle(::TestMasslessBoson) = false
QEDbase.mass(::TestMasslessBoson) = 0.0
QEDbase.charge(::TestMasslessBoson) = _CHARGE_TEST_BOSON

const PARTICLE_SET = [
    TestFermion(), TestMasslessFermion(), TestBoson(), TestMasslessBoson()
]

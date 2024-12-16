
# dummy particles
struct TestFermion <: FermionLike end
mass(::TestFermion) = _MASS_TEST_FERMION
charge(::TestFermion) = _CHARGE_TEST_FERMION

struct TestBoson <: BosonLike end
mass(::TestBoson) = _MASS_TEST_BOSON
charge(::TestBoson) = _CHARGE_TEST_BOSON

const PARTICLE_SET = [TestFermion(), TestBoson()]

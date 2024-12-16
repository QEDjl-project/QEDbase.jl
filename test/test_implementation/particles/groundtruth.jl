
# Numbers just for testing - they have no physical meaning

const _MASS_TEST_FERMION = 1.37
const _CHARGE_TEST_FERMION = 0.01

const _MASS_TEST_BOSON = 0.007
const _CHARGE_TEST_BOSON = 1.69

_groundtruth_fermion_propagator(mom) = prod(mom)
_groundtruth_boson_propagator(mom) = sum(mom)

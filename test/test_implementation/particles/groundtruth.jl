
# Numbers just for testing - they have no physical meaning

const _MASS_TEST_FERMION = 1.37
const _CHARGE_TEST_FERMION = 0.01

const _MASS_TEST_BOSON = 0.007
const _CHARGE_TEST_BOSON = 1.69

_groundtruth_fermion_propagator(mom) = prod(mom)
_groundtruth_boson_propagator(mom) = sum(mom)

_dir_sign(::Incoming) = 1
_dir_sign(::Outgoing) = -1

_spin_pol_sign(::SpinUp) = 1
_spin_pol_sign(::SpinDown) = -1
_spin_pol_sign(::PolX) = 1
_spin_pol_sign(::PolY) = -1

function _groundtruth_fermion_base_state(dir, mom, spin)
    return _dir_sign(dir) * (mom * mom) * _spin_pol_sign(spin)
end
function _groundtruth_massless_fermion_base_state(dir, mom, spin)
    return _dir_sign(dir) * getT(mom) * _spin_pol_sign(spin)
end
function _groundtruth_boson_base_state(dir, mom, pol)
    return _dir_sign(dir) / (mom * mom) * _spin_pol_sign(pol)
end
function _groundtruth_massless_boson_base_state(dir, mom, pol)
    return _dir_sign(dir) / getT(mom) * _spin_pol_sign(pol)
end

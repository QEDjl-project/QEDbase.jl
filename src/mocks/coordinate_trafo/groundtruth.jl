
_groundtruth_coord_trafo(p::AbstractMockMomentum) = 2 * p

# coord trafo applied to every momentum in psp
function _groundtruth_coord_trafo(psp::MockPhaseSpacePoint)
    in_moms = momenta(psp, Incoming())
    out_moms = momenta(psp, Outgoing())
    in_moms_prime = _groundtruth_coord_trafo.(in_moms)
    out_moms_prime = _groundtruth_coord_trafo.(out_moms)

    return MockPhaseSpacePoint(
        process(psp), model(psp), phase_space_definition(psp), in_moms_prime, out_moms_prime
    )
end


function _groundtruth_generate_momenta(
    ps_coords, mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractTestMomentum}
    moms = _furl_moms(ps_coords, mom_type)
    return moms
end

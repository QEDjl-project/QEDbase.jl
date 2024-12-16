
"""
    _groundtruth_in_moms(in_coords,mom_type)

Test implementation for building incoming momenta. Maps all components into four momenta.
"""
function _groundtruth_in_moms(
    in_coords, mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractTestMomentum}
    n = Int(length(in_coords) / 4)
    return NTuple{n}(map(mom_type, Iterators.partition(in_coords, 4)))
end

"""
    _groundtruth_out_moms(Ptot,out_coords)

Test implementation for building outgoing momenta. Maps all components into four momenta and adds
the last momentum via energy momentum conservation.
"""
function _groundtruth_out_moms(
    in_moms, out_coords, mom_type::Type{MOM_TYPE}
) where {MOM_TYPE<:AbstractTestMomentum}
    Ptot = sum(in_moms)
    n = Int(length(out_coords) / 4)
    if length(out_coords) == 0
        return (Ptot,)
    end
    moms_except_last = NTuple{n}(map(mom_type, Iterators.partition(out_coords, 4)))
    last_mom = Ptot - sum(moms_except_last)
    return (moms_except_last..., last_mom)
end

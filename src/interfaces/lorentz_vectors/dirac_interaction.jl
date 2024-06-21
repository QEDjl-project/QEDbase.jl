import Base: *

"""
$(TYPEDSIGNATURES)

Product of generic Lorentz vector with a Dirac tensor from the left. Basically, the multiplication is piped to the components from the Lorentz vector.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.
"""
function mul(
    DM::T, L::TL
) where {T<:Union{AbstractDiracMatrix,AbstractDiracVector},TL<:AbstractLorentzVector}
    return constructorof(TL)(DM * L[1], DM * L[2], DM * L[3], DM * L[4])
end
@inline function *(
    DM::T, L::TL
) where {T<:Union{AbstractDiracMatrix,AbstractDiracVector},TL<:AbstractLorentzVector}
    return mul(DM, L)
end

"""
$(TYPEDSIGNATURES)

Product of generic Lorentz vector with a Dirac tensor from the right. Basically, the multiplication is piped to the components from the Lorentz vector.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(
    L::TL, DM::T
) where {TL<:AbstractLorentzVector,T<:Union{AbstractDiracMatrix,AbstractDiracVector}}
    return constructorof(TL)(L[1] * DM, L[2] * DM, L[3] * DM, L[4] * DM)
end
@inline function *(
    L::TL, DM::T
) where {TL<:AbstractLorentzVector,T<:Union{AbstractDiracMatrix,AbstractDiracVector}}
    return mul(L, DM)
end

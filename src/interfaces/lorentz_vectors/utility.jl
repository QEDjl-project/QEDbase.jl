#######
#
# Utility functions on FourMomenta
#
#######

function isonshell(mom::QEDbase.AbstractLorentzVector{T}) where {T<:Real}
    mag2 = getMag2(mom)
    E = getE(mom)
    return isapprox(E^2, mag2; rtol=eps(T))
end

"""
$(SIGNATURES)

On-shell check of a given four-momentum `mom` w.r.t. a given mass `mass`.

!!! note "Precision"
    For `AbstractFourMomentum`, the element type defaults to `Float64`, limiting the precision of comparisons between elements.
    The current implementation has been tested within the boundaries for energy scales `E` with `1e-9 <= E <= 1e5`.
    In those bounds, the mass error, which is correctly detected as off-shell, is `1e-4` times the mean value of the components, but has at most the value `0.01`, e.g. at the high energy end.
    The energy scales correspond to `0.5 meV` for the lower bound and `50 GeV` for the upper bound.
"""
function isonshell(mom::QEDbase.AbstractLorentzVector{T}, mass::Real) where {T<:Real}
    if iszero(mass)
        return isonshell(mom)
    end
    mag2 = getMag2(mom)
    E = getE(mom)
    return isapprox(E^2, (mass)^2 + mag2; atol=2 * eps(T), rtol=eps(T))
end

"""
$(SIGNATURES)

Assertion if a FourMomentum `mom` is on-shell w.r.t a given mass `mass`.

!!! note "See also"
    The precision of this functions is explained in [`isonshell`](@ref).

"""
function assert_onshell(mom::QEDbase.AbstractLorentzVector, mass::Real)
    isonshell(mom, mass) || throw(OnshellError(mom, mass))
    return nothing
end

"""
submodule to model Dirac's gamma matrices.
"""

abstract type AbstractGammaRepresentation end

####
# generic definition of the gamma matrices
####

function gamma(::Type{T})::SLorentzVector where {T<:AbstractGammaRepresentation}
    return SLorentzVector(_gamma0(T), _gamma1(T), _gamma2(T), _gamma3(T))
end

####
# concrete implementatio of gamma matrices in Diracs representation
#
# Note: lower-index version of the gamma matrices are used
#       e.g. see https://en.wikipedia.org/wiki/Gamma_matrices
# Note: caused by the column major construction of matrices in Julia,
#       the definition below looks *transposed*.
#
####

struct DiracGammaRepresentation <: AbstractGammaRepresentation end

#! format: off
function _gamma0(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix{ComplexF64}(1, 0, 0, 0,
                       0, 1, 0, 0,
                       0, 0, -1, 0,
                       0, 0, 0, -1)
end

function _gamma1(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix{ComplexF64}(0, 0, 0, 1,
                       0, 0, 1, 0,
                       0, -1, 0, 0,
                       -1, 0, 0, 0)
end

function _gamma2(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix{ComplexF64}( 0,0,0,1im,
                        0,0,-1im,0,
                        0,-1im,0,0,
                        1im,0,0,0)
end

function _gamma3(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix{ComplexF64}(0, 0, 1, 0,
                       0, 0, 0, -1,
                       -1, 0, 0, 0,
                       0, 1, 0, 0)
end
#! format: on

# default gamma matrix is in Dirac's representation
gamma() = gamma(DiracGammaRepresentation)

const GAMMA = gamma()

# feynman slash notation

function slashed(
    ::Type{TG}, LV::TV
) where {TG<:AbstractGammaRepresentation,TV<:AbstractLorentzVector}
    return gamma(TG) * LV
end

function slashed(LV::T) where {T<:AbstractLorentzVector}
    return GAMMA * LV
end

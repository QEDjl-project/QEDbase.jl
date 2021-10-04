"""
submodule to model Dirac's gamma matrices.
"""

abstract type AbstractGammaRepresentation end

####
# generic definition of the gamma matrices
####

function gamma(::Type{T})::LorentzVector where T<:AbstractGammaRepresentation
    return LorentzVector( _gamma0(T), _gamma1(T), _gamma2(T), _gamma3(T))
end



####
# concrete implementatio of gamma matrices in Diracs representation
####

struct DiracGammaRepresentation <: AbstractGammaRepresentation end


function _gamma0(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix( 1,0,0,0,
                        0,1,0,0,
                        0,0,-1,0,
                        0,0,0,-1)
end

function _gamma1(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix( 0,0,0,1,
                        0,0,1,0,
                        0,-1,0,0,
                        -1,0,0,0)
end

function _gamma2(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix( 0,0,0,-1im,
                        0,0,1im,0,
                        0,1im,0,0,
                        -1im,0,0,0)
end

function _gamma3(::Type{DiracGammaRepresentation})::DiracMatrix
    return DiracMatrix( 0,0,1,0,
                        0,0,0,-1,
                        -1,0,0,0,
                        0,1,0,0)
end

# default gamma matrix is in Dirac's representation
gamma() = gamma(DiracGammaRepresentation)

const GAMMA = gamma()

####
# generic definition of the gamma matrices
####

abstract type AbstractGammaRepresentation end

function gamma(::Type{T})::SLorentzVector where {T<:AbstractGammaRepresentation}
    return SLorentzVector(_gamma0(T), _gamma1(T), _gamma2(T), _gamma3(T))
end


abstract type AbstractPhaseSpacePoint{
    PROC<:AbstractProcessDefinition,
    MODEL<:AbstractModelDefinition,
    PSDEF<:AbstractPhasespaceDefinition,
    IN_PARTICLES<:Tuple{Vararg{AbstractParticleStateful}},
    OUT_PARTICLES<:Tuple{Vararg{AbstractParticleStateful}},
    ELEMENT<:AbstractFourMomentum,
} end

"""
    AbstractInPhaseSpacePoint

A partial type specialization on [`AbstractPhaseSpacePoint`](@ref) which can be used for dispatch in functions requiring only the in channel of the phase space to exist, for example implementations of [`_incident_flux`](@ref). No restrictions are imposed on the out-channel, which may or may not exist.

See also: [`AbstractOutPhaseSpacePoint`](@ref)
"""
AbstractInPhaseSpacePoint{P,M,D,IN,OUT,E} = AbstractPhaseSpacePoint{
    P,M,D,IN,OUT,E
} where {PS<:AbstractParticleStateful,IN<:Tuple{PS,Vararg},OUT<:Tuple{Vararg}}

"""
    AbstractOutPhaseSpacePoint

A partial type specialization on [`AbstractPhaseSpacePoint`](@ref) which can be used for dispatch in functions requiring only the out channel of the phase space to exist. No restrictions are imposed on the in-channel, which may or may not exist.

See also: [`AbstractInPhaseSpacePoint`](@ref)
"""
AbstractOutPhaseSpacePoint{P,M,D,IN,OUT,E} = AbstractPhaseSpacePoint{
    P,M,D,IN,OUT,E
} where {PS<:AbstractParticleStateful,IN<:Tuple{Vararg},OUT<:Tuple{PS,Vararg}}

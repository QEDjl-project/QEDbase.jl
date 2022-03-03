"""
LorentzVectors
"""

#######
#
# Abstract types
#
#######
"""
$(TYPEDEF)

Abstract type to model generic Lorentz vectors, i.e. elements of a minkowski-like space, where the component space is arbitray.
"""
abstract type AbstractLorentzVector{T} <: FieldVector{4, T} end


#######
#
# Generic Methods on LorentzVectors
#
#######
"""
$(TYPEDSIGNATURES)

Generic dot function to model the minkowski dot of Lorentz vectors. In order to make this work with any concrete implementation `T<:AbstractLorentzVector` the components of `T` need to be accessable via indexing, e.g. for `p::T` the indexing `p[2]` needs to return the x-component (which is the 1-component in null-based indexing, e.g. used in special relativity). Furthermore, for the components, the arithmetic operators `+` and `*` needs to be implemented, e.g. `p[1]*p[1] + p[2]*p[2]` needs to be valid.

!!! note "metric signature"
    Here we use the mostly-minus metric, i.e. the signatur ```(+,-,-,-)```:

    ```julia
    dot(p1,p2) == p1[1]*p2[1] - p1[2]*p2[2] - p1[3]*p2[3] - p1[4]*p2[4]
    ```

"""
function dot(p1::T1,p2::T2) where {T1<:AbstractLorentzVector,T2<:AbstractLorentzVector}
    @inbounds p1[1]*p2[1] - p1[2]*p2[2] - p1[3]*p2[3] - p1[4]*p2[4]
end
@inline *(p1::T1,p2::T2) where {T1<:AbstractLorentzVector,T2<:AbstractLorentzVector} = dot(p1,p2)


"""
$(TYPEDSIGNATURES)

Return the magnitude of a given LorentzVector w.r.t. the Minkowski-dot product. Raises an error, if the Minkowski-square `dot(p,p)` of a Lorentz vector `p` is negative.

!!! waring "Comparison and zero"
    For that check, the comparison operator `<` and the `zero` needs to be implemented for the components of the Lorentz vector.

"""
function magnitude(p::T) where T<:AbstractLorentzVector
    mag2 = dot(p,p)
    if mag2<zero(mag2)
        throw(error("There is no magnitude of given LorentzVector. The Minkowski product is negative! {$mag2} "))
    end
    sqrt(mag2)
end



#interface with dirac tensors
"""
$(TYPEDSIGNATURES)

Product product of generic Lorentz vector with a Dirac tensor from the left. Basically, the multiplication is piped to the components from the Lorentz vector.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(DM::T,L::TL) where {T<:Union{AbstractDiracMatrix,AbstractDiracVector},TL<:AbstractLorentzVector}
    LorentzVector(DM*L[1],DM*L[2],DM*L[3],DM*L[4])
end
@inline *(DM::T,L::TL) where {T<:Union{AbstractDiracMatrix,AbstractDiracVector},TL<:AbstractLorentzVector} = mul(DM,L)

"""
$(TYPEDSIGNATURES)

Product product of generic Lorentz vector with a Dirac tensor from the right. Basically, the multiplication is piped to the components from the Lorentz vector.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(L::TL,DM::T) where {TL<:AbstractLorentzVector,T<:Union{AbstractDiracMatrix,AbstractDiracVector}}
    LorentzVector(L[1]*DM,L[2]*DM,L[3]*DM,L[4]*DM)
end
@inline *(L::TL,DM::T) where {TL<:AbstractLorentzVector,T<:Union{AbstractDiracMatrix,AbstractDiracVector}} = mul(L,DM)



#######
#
# Concrete LorentzVector type
#
#######
"""
$(TYPEDEF)

Concrete implementation of a generic Lorentz vector. Each manipulation of an concrete implementation which is not self-contained (i.e. produces the same Lorentz vector type) will result in this type.

# Fields
$(TYPEDFIELDS)
"""
struct LorentzVector{T} <: AbstractLorentzVector{T}

    "`t` component"
    t::T

    "`x` component"
    x::T

    "`y` component"
    y::T

    "`z` component"
    z::T
end

LorentzVector(t, x, y, z) = LorentzVector(promote(t, x, y, z)...)


function similar_type(::Type{A},::Type{T},::Size{S}) where {A<: LorentzVector,T,S}
    LorentzVector{T}
end

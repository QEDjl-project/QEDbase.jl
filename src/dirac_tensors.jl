"""
Dirac Tensors
"""
#######
#
# Abstract Dirac Tensor types
#
#######
"""
$(TYPEDEF)

Abstract type for Dirac vectors, e.g. four dimensional vectors from a spinor space.
"""
abstract type AbstractDiracVector{T} <: FieldVector{4,T} end

"""
$(TYPEDEF)

Abstract type for Dirac matrices, i.e. matrix representations for linear mappings from a spinor space into another.
"""
abstract type AbstractDiracMatrix{T} <: FieldMatrix{4,4,T} end

#######
#
# Concrete Dirac Tensor types
#
#######
"""
$(TYPEDEF)

Concrete type to model a Dirac four-spinor with complex-valued components. These are the elements of an actual spinor space.
"""
struct BiSpinor{T<:Number} <: AbstractDiracVector{T}
    el1::T
    el2::T
    el3::T
    el4::T
end
BiSpinor(mat::AbstractVector{T}) where {T<:Number} = BiSpinor{T}(mat)
similar_type(::Type{A}, ::Type{ElType}) where {A<:BiSpinor,ElType} = BiSpinor{ElType}
BiSpinor(sv::SVector{4,T}) where {T} = BiSpinor{T}(Tuple(sv))

"""
$(TYPEDEF)

Concrete type to model an adjoint Dirac four-spinor with complex-valued components. These are the elements of the dual spinor space.
"""
struct AdjointBiSpinor{T<:Number} <: AbstractDiracVector{T}
    el1::T
    el2::T
    el3::T
    el4::T
end
AdjointBiSpinor(mat::AbstractVector{T}) where {T<:Number} = AdjointBiSpinor{T}(mat)
function similar_type(::Type{A}, ::Type{ElType}) where {A<:AdjointBiSpinor,ElType}
    return AdjointBiSpinor{ElType}
end
AdjointBiSpinor(sv::SVector{4,T}) where {T} = AdjointBiSpinor{T}(Tuple(sv))

#######
#interface
AdjointBiSpinor(spn::BiSpinor) = AdjointBiSpinor(conj(SVector(spn)))
BiSpinor(spn::AdjointBiSpinor) = BiSpinor(conj(SVector(spn)))

"""
$(TYPEDEF)

Concrete type to model Dirac matrices, i.e. matrix representations of linear mappings between two spinor spaces.
"""
struct DiracMatrix{T<:Number} <: AbstractDiracMatrix{T}
    el11::T
    el12::T
    el13::T
    el14::T
    el21::T
    el22::T
    el23::T
    el24::T
    el31::T
    el32::T
    el33::T
    el34::T
    el41::T
    el42::T
    el43::T
    el44::T
end

DiracMatrix(mat::AbstractMatrix{T}) where {T<:Number} = DiracMatrix{T}(mat)

DiracMatrix(sm::SMatrix{4,4,T,16}) where {T} = DiracMatrix{T}(Tuple(sm))
#######
#
# Concrete implementation of multiplication for Dirac Tensors
#
#######
"""
$(TYPEDSIGNATURES)

Tensor product of an adjoint with a standard bi-spinor resulting in a scalar.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(aBS::AdjointBiSpinor, BS::BiSpinor)
    return transpose(aBS) * BS
end
@inline *(aBS::AdjointBiSpinor, BS::BiSpinor) = mul(aBS::AdjointBiSpinor, BS::BiSpinor)

"""
$(TYPEDSIGNATURES)

Tensor product of a standard with an adjoint bi-spinor resulting in a Dirac matrix.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(BS::BiSpinor, aBS::AdjointBiSpinor)
    return DiracMatrix(BS * transpose(aBS))
end
@inline *(BS::BiSpinor, aBS::AdjointBiSpinor) = mul(BS, aBS)

"""
$(TYPEDSIGNATURES)

Tensor product of an Dirac matrix with a standard bi-spinor resulting in another standard bi-spinor.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(DM::DiracMatrix, BS::BiSpinor)
    return BiSpinor(SMatrix(DM) * SVector(BS))
end
@inline *(DM::DiracMatrix, BS::BiSpinor) = mul(DM, BS)

"""
$(TYPEDSIGNATURES)

Tensor product of an adjoint bi-spinor with a Dirac matrix resulting in another adjoint bi-spinor.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(aBS::AdjointBiSpinor, DM::DiracMatrix)
    return AdjointBiSpinor(transpose(aBS) * DM)
end
@inline *(aBS::AdjointBiSpinor, DM::DiracMatrix) = mul(aBS, DM)

"""
$(TYPEDSIGNATURES)

Tensor product two Dirac matrices resulting in another Dirac matrix.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(DM1::DiracMatrix, DM2::DiracMatrix)
    return DM1 * DM2
end

"""
$(TYPEDSIGNATURES)

Tensor product of Dirac matrix sandwiched between an adjoint and a standard bi-spinor resulting in a scalar.
"""
function mul(aBS::AdjointBiSpinor, DM::DiracMatrix, BS::BiSpinor)
    return transpose(aBS) * DM * BS
end

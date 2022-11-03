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
struct BiSpinor <: AbstractDiracVector{ComplexF64}
    el1::ComplexF64
    el2::ComplexF64
    el3::ComplexF64
    el4::ComplexF64
end

"""
$(TYPEDEF)

Concrete type to model an adjoint Dirac four-spinor with complex-valued components. These are the elements of the dual spinor space.
"""
struct AdjointBiSpinor <: AbstractDiracVector{ComplexF64}
    el1::ComplexF64
    el2::ComplexF64
    el3::ComplexF64
    el4::ComplexF64
end

#interface
AdjointBiSpinor(spn::BiSpinor) = AdjointBiSpinor(conj(SVector(spn)))
BiSpinor(spn::AdjointBiSpinor) = BiSpinor(conj(SVector(spn)))

"""
$(TYPEDEF)

Concrete type to model Dirac matrices, i.e. matrix representations of linear mappings between two spinor spaces.
"""
struct DiracMatrix <: AbstractDiracMatrix{ComplexF64}
    el11::ComplexF64
    el12::ComplexF64
    el13::ComplexF64
    el14::ComplexF64
    el21::ComplexF64
    el22::ComplexF64
    el23::ComplexF64
    el24::ComplexF64
    el31::ComplexF64
    el32::ComplexF64
    el33::ComplexF64
    el34::ComplexF64
    el41::ComplexF64
    el42::ComplexF64
    el43::ComplexF64
    el44::ComplexF64
end

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
function mul(aBS::AdjointBiSpinor, BS::BiSpinor)::ComplexF64
    return transpose(aBS) * BS
end
@inline *(aBS::AdjointBiSpinor, BS::BiSpinor) = mul(aBS::AdjointBiSpinor, BS::BiSpinor)

"""
$(TYPEDSIGNATURES)

Tensor product of a standard with an adjoint bi-spinor resulting in a Dirac matrix.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(BS::BiSpinor, aBS::AdjointBiSpinor)::DiracMatrix
    return DiracMatrix(BS * transpose(aBS))
end
@inline *(BS::BiSpinor, aBS::AdjointBiSpinor) = mul(BS::BiSpinor, aBS::AdjointBiSpinor)

"""
$(TYPEDSIGNATURES)

Tensor product of an Dirac matrix with a standard bi-spinor resulting in another standard bi-spinor.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(DM::DiracMatrix, BS::BiSpinor)::BiSpinor
    return DM * BS
end

"""
$(TYPEDSIGNATURES)

Tensor product of an adjoint bi-spinor with a Dirac matrix resulting in another adjoint bi-spinor.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(aBS::AdjointBiSpinor, DM::DiracMatrix)::AdjointBiSpinor
    return transpose(aBS) * DM
end
@inline *(aBS::AdjointBiSpinor, DM::DiracMatrix) = mul(aBS, DM)

"""
$(TYPEDSIGNATURES)

Tensor product two Dirac matrices resulting in another Dirac matrix.

!!! note "Multiplication operator"
    This also overloads the `*` operator for this types.

"""
function mul(DM1::DiracMatrix, DM2::DiracMatrix)::DiracMatrix
    return DM1 * DM2
end

"""
$(TYPEDSIGNATURES)

Tensor product of Dirac matrix sandwiched between an adjoint and a standard bi-spinor resulting in a scalar.
"""
function mul(aBS::AdjointBiSpinor, DM::DiracMatrix, BS::BiSpinor)::ComplexF64
    return transpose(aBS) * DM * BS
end

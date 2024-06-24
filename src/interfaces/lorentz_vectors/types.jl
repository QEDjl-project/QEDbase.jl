#######
#
# Abstract types
#
#######
"""
$(TYPEDEF)

Abstract type to model generic Lorentz vectors, i.e. elements of a minkowski-like space, where the component space is arbitray.
"""
abstract type AbstractLorentzVector{T} <: FieldVector{4,T} end

"""
## Definition of LorentzVector interface.

It enables several functions related to Lorentz vectors for any custom type just by implementing the API for the respective type.
For instance, say we want to implement a type, which shall act like a Lorentz vector. Then, we start with our custom type:

```julia
struct CustomType
    t::Float64
    x::Float64
    y::Float64
    z::Float64
end
```
The first group of functions to be implemented for this `CustomType` in order to connect this type to the Lorentz vector interface are the getter for the cartesian components.

```julia
QEDbase.getT(lv::CustomType) = lv.t
QEDbase.getX(lv::CustomType) = lv.x
QEDbase.getY(lv::CustomType) = lv.y
QEDbase.getZ(lv::CustomType) = lv.z
```
Make sure that you dispatch on the getter from `QEDbase` by defining `QEDbase.getT`, etc.

With this done, we can aleady register the `CustomType` as a `LorentzVectorLike` type using the `register_LorentzVectorLike` function
```julia
register_LorentzVectorLike(CustomType)
```
If something goes wrong, this function call will raise an `RegistryError` indicating, what is missing. With this done, `CustomType` is ready to be used as a `LorentzVectorLike`
```julia
L = CustomType(2.0,1.0,0.0,-1.0)

getTheta(L) # 
getRapidity(L) # 
```

"""

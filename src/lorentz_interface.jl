"""
Here the lorentz vector interface is defined. It is based on the trait `LorentzVectorStyle`, which has two states 

```Julia
    IsLorentzVectorLike <: LorentzVectorStyle
    NotLorentzVectorLike <: LorentzVectorStyle
````
In order to use the lorentz vector library, one needs to implement a custom type, e.g.

```Julia
struct CustomType
    t::Float64
    x::Float64
    y::Float64
    z::Float64
end
```
For this `CustomType`, one need to overload the functions
`getT`, `getX`, `getY`, and `getZ` from `QEDbase`:

```Julia
QEDbase.getT(lv::CustomType) = lv.t
QEDbase.getX(lv::CustomType) = lv.x
QEDbase.getY(lv::CustomType) = lv.y
QEDbase.getZ(lv::CustomType) = lv.z
```
With this done, one can register the `CustomType` as a `LorentzVectorLike` type,
which enables generic functions like:

```Julia
L = CustomType(2.0,1.0,0.0,-1.0)

get_polar_angle(L) # ≈3.1415
get_rapidity(L) # 
...
```
"""

struct RegistryError <: Exception
    func::Function
    target_type
end


function Base.showerror(io::IO, err::RegistryError)
    println(io,"RegistryError:"," The type <$(err.target_type)> must implement <$(err.func)> to be registered.")
end

function _hasmethod_registry(fun::Function,::Type{T}) where T
	@argcheck hasmethod(fun,Tuple{T}) RegistryError(fun,T)
end


@traitdef IsLorentzVectorLike{T}


function getT end
function getX end
function getY end
function getZ end



function register_LorentzVectorLike(T::Type)
    _hasmethod_registry(getT, T)
    _hasmethod_registry(getX, T)
    _hasmethod_registry(getY, T)
    _hasmethod_registry(getZ, T)
    
    @eval @traitimpl IsLorentzVectorLike{$T}
    return 
end

# general functions

@inline @traitfn minkowski_dot(x1::T,x2::T) where {T; IsLorentzVectorLike{T}} = getT(x1)*getT(x2) - (getX(x1)*getX(x2) + getY(x1)*getY(x2) + getZ(x1)*getZ(x2))
const mdot = minkowski_dot

@inline @traitfn magnitude2(lv::T) where {T; IsLorentzVectorLike{T}} = getX(lv)^2 + getY(lv)^2 + getZ(lv)^2
const mag2 = magnitude2

@inline @traitfn magnitude(lv::T)  where {T; IsLorentzVectorLike{T}} = sqrt(magnitude2(lv))
const mag = magnitude

@inline @traitfn invariant_mass2(lv::T)  where {T; IsLorentzVectorLike{T}} = minkowski_dot(lv,lv)
const mass2 = invariant_mass2

@inline @traitfn invariant_mass(lv::T)  where {T; IsLorentzVectorLike{T}} = sqrt(invariant_mass2(lv))
const mass = invariant_mass


# Momentum specific getter

@inline @traitfn getE(lv::T)  where {T; IsLorentzVectorLike{T}} =  getT(lv)
@inline @traitfn getPx(lv::T)  where {T; IsLorentzVectorLike{T}} =  getX(lv)
@inline @traitfn getPy(lv::T)  where {T; IsLorentzVectorLike{T}} =  getY(lv)
@inline @traitfn getPz(lv::T)  where {T; IsLorentzVectorLike{T}} =  getZ(lv)

# spherical coordinates
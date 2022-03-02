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

getTheta(L) # 
getRapidity(L) # 
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

function setT! end
function setX! end
function setY! end
function setZ! end



function register_LorentzVectorLike(T::Type)
    _hasmethod_registry(getT, T)
    _hasmethod_registry(getX, T)
    _hasmethod_registry(getY, T)
    _hasmethod_registry(getZ, T)
    
    @eval @traitimpl IsLorentzVectorLike{$T}

    if hasmethod(setT!,Tuple{T})&&hasmethod(setX!,Tuple{T})&&hasmethod(setY!,Tuple{T})&&hasmethod(setZ!,Tuple{T})
        @eval @traitimpl IsMutableLorentzVectorLike{$T}
    end
    return 
end

# general functions


@inline @traitfn minkowski_dot(x1::T,x2::T) where {T; IsLorentzVectorLike{T}} = getT(x1)*getT(x2) - (getX(x1)*getX(x2) + getY(x1)*getY(x2) + getZ(x1)*getZ(x2))
minkowski_dot(x::T1,y::T2) where {T1,T2} = minkowski_dot(promote(x,y)...)
const mdot = minkowski_dot

@inline @traitfn getMagnitude2(lv::T) where {T; IsLorentzVectorLike{T}} = getX(lv)^2 + getY(lv)^2 + getZ(lv)^2
const getMag2 = getMagnitude2

@inline @traitfn getMagnitude(lv::T)  where {T; IsLorentzVectorLike{T}} = sqrt(getMagnitude2(lv))
const getMag = getMagnitude

@inline @traitfn getInvariantMass2(lv::T)  where {T; IsLorentzVectorLike{T}} = minkowski_dot(lv,lv)
const getMass2 = getInvariantMass2

@traitfn function getInvariantMass(lv::T)  where {T; IsLorentzVectorLike{T}} 
    m2 = getInvariantMass2(lv)
    if m2<zero(m2)
        # Think about including this waring, maybe optional with a global PRINT_WARINGS switch.
        #@warn("The square of the invariant mass (m2=P*P) is negative. The value -sqrt(-m2) is returned.")
        return -sqrt(-m2)
    else
        return sqrt(m2)
    end
end
const getMass = getInvariantMass


# Momentum specific getter

@inline @traitfn getE(lv::T)  where {T; IsLorentzVectorLike{T}} =  getT(lv)
const getEnergy = getE
@inline @traitfn getPx(lv::T)  where {T; IsLorentzVectorLike{T}} =  getX(lv)
@inline @traitfn getPy(lv::T)  where {T; IsLorentzVectorLike{T}} =  getY(lv)
@inline @traitfn getPz(lv::T)  where {T; IsLorentzVectorLike{T}} =  getZ(lv)

@inline @traitfn function getBeta(lv::T)  where {T; IsLorentzVectorLike{T}}
    if getT(lv)!=zero(getT(lv))
        getRho(lv)/getT(lv)
    else
        throw(error("There is no beta for a LorentzVectorLike with vanishing time/energy component"))
    end
end

@inline @traitfn getGamma(lv::T)  where {T; IsLorentzVectorLike{T}} =  inv(sqrt(one(getT(lv))-getBeta(lv)^2))

# transverse coordinates
@inline @traitfn getTransverseMomentum2(lv::T)  where {T; IsLorentzVectorLike{T}} = getX(lv)^2 + getY(lv)^2
const getPt2 = getTransverseMomentum2
const getPerp2 = getTransverseMomentum2
@inline @traitfn getTransverseMomentum(lv::T)  where {T; IsLorentzVectorLike{T}} = sqrt(getTransverseMomentum2(lv))
const getPt = getTransverseMomentum
const getPerp = getTransverseMomentum

@inline @traitfn getTransverseMass2(lv::T)  where {T; IsLorentzVectorLike{T}} = getT(lv)^2 - getZ(lv)^2
const getMt2 = getTransverseMass2
@traitfn function getTransverseMass(lv::T)  where {T; IsLorentzVectorLike{T}}
    mT2 = getTransverseMass2(lv)
    if mT2<zero(mT2)
        # add optional waring: negative transverse mass -> -sqrt(-mT2) is returned.
        -sqrt(-mT2)
    else
        sqrt(mT2)
    end
end
const getMt = getTransverseMass


@inline @traitfn getRapidity(lv::T)  where {T; IsLorentzVectorLike{T}} = 0.5*log((getT(lv) + getZ(lv))/(getT(lv) - getZ(lv)))

# spherical coordinates
const getRho2 = getMagnitude2
const getRho = getMagnitude 

@inline @traitfn function getTheta(lv::T)  where {T; IsLorentzVectorLike{T}}
    getX(lv)==zero(getX(lv)) && getY(lv)==zero(getY(lv)) && getZ(lv)==zero(getZ(lv)) ? zero(getX(lv)) : atan(getTransverseMomentum(lv),getZ(lv))
end

@traitfn function getCosTheta(lv::T)  where {T; IsLorentzVectorLike{T}}
    r = getRho(lv)
    r==zero(getX(lv)) ? zero(getX(lv)) : getZ(lv)/r
end

@traitfn function getPhi(lv::T)  where {T; IsLorentzVectorLike{T}}
    n = zero(getX(lv))
    getX(lv)==n && getY(lv)==n ? n : atan(getY(lv),getX(lv))
end


# light cone coordinates
@inline @traitfn getPlus(lv::T)  where {T; IsLorentzVectorLike{T}} = 0.5*(getT(lv) + getZ(lv))
@inline @traitfn getMinus(lv::T)  where {T; IsLorentzVectorLike{T}} = 0.5*(getT(lv) - getZ(lv))


####
#
# Setter
#
####

@inline @traitfn setPy!(lv::T,value::VT)  where {T,VT; IsLorentzVectorLike{T}} =  setY!(lv,value)
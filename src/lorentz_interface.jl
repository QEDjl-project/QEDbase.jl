"""
Here the Lorentz vector interface is defined. It enables several functions related to Lorentz vectors for any custom type just by implementing the API for the respective type.
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
```juila
register_LorentzVectorLike(CustomType)
```
If something goes wrong, this function call will raise an `RegistryError` indicating, what is missing. With this done, `CustomType` is ready to be used as a LorentzVectorLike
```Julia
L = CustomType(2.0,1.0,0.0,-1.0)

getTheta(L) # 
getRapidity(L) # 
```

"""


"""

$(TYPEDEF)

Exception raised, if a certain type `target_type` can not be registed for a certain interface, since there needs the function `func` to be impleemnted.

# Fields
$(TYPEDFIELDS)

"""
struct RegistryError <: Exception
    func::Function
    target_type
end


function Base.showerror(io::IO, err::RegistryError)
    println(io,"RegistryError:"," The type <$(err.target_type)> must implement <$(err.func)> to be registered.")
end

"""
$(SIGNATURES)

Wrapper around `Base.hasmethod` with a more meaningful error message in the context of function registration.
"""
function _hasmethod_registry(fun::Function,::Type{T}) where T
	@argcheck hasmethod(fun,Tuple{T}) RegistryError(fun,T)
end


@traitdef IsLorentzVectorLike{T}
@traitdef IsMutableLorentzVectorLike{T}



"""

    getT(lv)

Return the 0-component of a given `LorentzVectorLike`.

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `t`.

"""
function getT end

"""

    getX(lv)

Return the 1-component of a given `LorentzVectorLike`.

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `x`.

"""
function getX end

"""

    getY(lv)

Return the 2-component of a given `LorentzVectorLike`.

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `y`.

"""
function getY end

"""

    getZ(lv)

Return the 3-component of a given `LorentzVectorLike`.

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `z`.

"""
function getZ end

"""

    setT!(lv,value)

Sets the 0-component of a given `LorentzVectorLike` to the given `value`.
"""
function setT! end

"""

    setX!(lv,value)

Sets the 1-component of a given `LorentzVectorLike` to the given `value`.
"""
function setX! end

"""

    setY!(lv,value)

Sets the 2-component of a given `LorentzVectorLike` to the given `value`.
"""
function setY! end

"""

    setZ!(lv,value)

Sets the 3-component of a given `LorentzVectorLike` to the given `value`.
"""
function setZ! end


"""
$(SIGNATURES)

Function to register a custom type as a LorentzVectorLike. 

This makes sure, the passed custom type has implemented at least the function `getT, getX, getY, getZ` 
and enables getter functions of the lorentz vector libray for the given type. 
If additionally the functions `setT!,setX!,setY!,setZ!` are implemened for the passed custom type,
also the setter functions of the Lorentz vector interface are enable.
"""
function register_LorentzVectorLike(T::Type)
    _hasmethod_registry(getT, T)
    _hasmethod_registry(getX, T)
    _hasmethod_registry(getY, T)
    _hasmethod_registry(getZ, T)
    
    @eval @traitimpl IsLorentzVectorLike{$T}

    if hasmethod(setT!,Tuple{T,Union{}})&&hasmethod(setX!,Tuple{T,Union{}})&&hasmethod(setY!,Tuple{T,Union{}})&&hasmethod(setZ!,Tuple{T,Union{}})
        @eval @traitimpl IsMutableLorentzVectorLike{$T}
    end
    return 
end




"""
    
    minkowski_dot(v1,v2)

Return the Minkowski dot product of two `LorentzVectorLike`. 

!!! example

    If `(t1,x1,y1,z1)` and `(t2,x2,y2,z2)` are two `LorentzVectorLike`, this is equivalent to 
    ```julia
    t1*t2 - (x1*x2 + y1*y2 + z1*z2)
    ```

!!! note

    Here we use the mostly minus metric.

"""
@inline @traitfn minkowski_dot(x1::T1,x2::T2) where {T1,T2; IsLorentzVectorLike{T1},IsLorentzVectorLike{T2}} = getT(x1)*getT(x2) - (getX(x1)*getX(x2) + getY(x1)*getY(x2) + getZ(x1)*getZ(x2))

"""
Function alias for [`minkowski_dot`](@ref).
"""
const mdot = minkowski_dot


########
# getter
########
"""
    
    getMagnitude2(lv)

Return the square of the magnitude of a given `LorentzVectorLike`, i.e. the sum of the squared spatial components. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `x^2+ y^2 + z^2`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline @traitfn getMagnitude2(lv::T) where {T; IsLorentzVectorLike{T}} = getX(lv)^2 + getY(lv)^2 + getZ(lv)^2

"""
Functiom alias for [`getMagnitude2`](@ref).
"""
const getMag2 = getMagnitude2


"""

    getMagnitude(lv)

Return the magnitude of a given `LorentzVectorLike`, i.e. the euklidian norm spatial components. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `sqrt(x^2+ y^2 + z^2)`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline @traitfn getMagnitude(lv::T)  where {T; IsLorentzVectorLike{T}} = sqrt(getMagnitude2(lv))

"""
Functiom alias for [`getMagnitude`](@ref).
"""
const getMag = getMagnitude


"""

    getInvariantMass2(lv)

Return the squared invariant mass of a given `LorentzVectorLike`, i.e. the minkowski dot with itself. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `t^2 - (x^2+ y^2 + z^2)`. 


"""
@inline @traitfn getInvariantMass2(lv::T)  where {T; IsLorentzVectorLike{T}} = minkowski_dot(lv,lv)

"""Function alias for [`getInvariantMass2`](@ref)"""
const getMass2 = getInvariantMass2

"""

    getInvariantMass(lv)

Return the the invariant mass of a given `LorentzVectorLike`, i.e. the square root of the minkowski dot with itself. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `sqrt(t^2 - (x^2+ y^2 + z^2))`.


!!! note
    
    If the squared invariant mass `m2` is negative, `-sqrt(-m2)` is returned. 

"""
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

"""Function alias for [`getInvariantMass`](@ref)."""
const getMass = getInvariantMass


##########################
# Momentum specific getter
##########################

"""

    getE(lv)

Return the energy component of a given `LorentzVectorLike`, i.e. its 0-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `E`.

"""
@inline @traitfn getE(lv::T)  where {T; IsLorentzVectorLike{T}} =  getT(lv)

"""Function alias for [`getE`](@ref)."""
const getEnergy = getE


"""

    getPx(lv)

Return the ``p_x`` component of a given `LorentzVectorLike`, i.e. its 1-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `px`.

"""
@inline @traitfn getPx(lv::T)  where {T; IsLorentzVectorLike{T}} =  getX(lv)

"""

    getPy(lv)

Return the ``p_y`` component of a given `LorentzVectorLike`, i.e. its 2-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `py`.

"""
@inline @traitfn getPy(lv::T)  where {T; IsLorentzVectorLike{T}} =  getY(lv)

"""

    getPz(lv)

Return the ``p_z`` component of a given `LorentzVectorLike`, i.e. its 3-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `pz`.

"""
@inline @traitfn getPz(lv::T)  where {T; IsLorentzVectorLike{T}} =  getZ(lv)

"""

    getBeta(lv)

Return magnitude of the beta vector for a given `LorentzVectorLike`, i.e. the magnitude of the `LorentzVectorLike` divided by its 0-component.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `sqrt(px^2 + py^2 + pz^2)/E`.

"""
@inline @traitfn function getBeta(lv::T)  where {T; IsLorentzVectorLike{T}}
    if getT(lv)!=zero(getT(lv))
        getRho(lv)/getT(lv)
    elseif getRho(lv) == zero(getT(lv))
        return zero(getT(lv))
    else
        throw(error("There is no beta for a LorentzVectorLike with vanishing time/energy component"))
    end
end

"""

    getGamma(lv)

Return the relativistic gamma factor for a given `LorentzVectorLike`, i.e. the inverse square root of one minus the beta vector squared.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike` with beta vector `β`, this is equivalent to `1/sqrt(1- β^2)`.

"""
@inline @traitfn getGamma(lv::T)  where {T; IsLorentzVectorLike{T}} =  inv(sqrt(one(getT(lv))-getBeta(lv)^2))


########################
# transverse coordinates
########################
"""

    getTransverseMomentum2(lv)

Return the squared transverse momentum for a given `LorentzVectorLike`, i.e. the sum of its squared 1- and 2-component.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `px^2 + py^2`.

!!! note

    The transverse components are defined w.r.t. to the 3-axis. 

"""
@inline @traitfn getTransverseMomentum2(lv::T)  where {T; IsLorentzVectorLike{T}} = getX(lv)^2 + getY(lv)^2

"""Function alias for [`getTransverseMomentum2`](@ref)."""
const getPt2 = getTransverseMomentum2
"""Function alias for [`getTransverseMomentum2`](@ref)."""
const getPerp2 = getTransverseMomentum2

"""

    getTransverseMomentum(lv)

Return the transverse momentum for a given `LorentzVectorLike`, i.e. the magnitude of its transverse components.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `sqrt(px^2 + py^2)`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis. 


"""
@inline @traitfn getTransverseMomentum(lv::T)  where {T; IsLorentzVectorLike{T}} = sqrt(getTransverseMomentum2(lv))
"""Function alias for [`getTransverseMomentum`](@ref)."""
const getPt = getTransverseMomentum
"""Function alias for [`getTransverseMomentum`](@ref)."""
const getPerp = getTransverseMomentum

"""

    getTransverseMass2(lv)

Return the squared transverse mass for a given `LorentzVectorLike`, i.e. the difference of its squared 0- and 3-component.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `E^2 - pz^2`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis. 


"""
@inline @traitfn getTransverseMass2(lv::T)  where {T; IsLorentzVectorLike{T}} = getT(lv)^2 - getZ(lv)^2
"""Function alias for [`getTransverseMass2`](@ref)"""
const getMt2 = getTransverseMass2

"""

    getTransverseMass(lv)

Return the transverse momentum for a given `LorentzVectorLike`, i.e. the square root of its squared transverse mass.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `sqrt(E^2 - pz^2)`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis. 

!!! note

    If the squared transverse mass `mT2` is negative, `-sqrt(-mT2)` is returned.

"""
@traitfn function getTransverseMass(lv::T)  where {T; IsLorentzVectorLike{T}}
    mT2 = getTransverseMass2(lv)
    if mT2<zero(mT2)
        # add optional waring: negative transverse mass -> -sqrt(-mT2) is returned.
        -sqrt(-mT2)
    else
        sqrt(mT2)
    end
end
"""Function alias for [`getTransverseMass`](@ref)"""
const getMt = getTransverseMass

"""

    getRapidity(lv)

Return the [rapidity](https://en.wikipedia.org/wiki/Rapidity) for a given `LorentzVectorLike`.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `log((E+pz)/(E-pz))`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis. 

"""
@inline @traitfn getRapidity(lv::T)  where {T; IsLorentzVectorLike{T}} = 0.5*log((getT(lv) + getZ(lv))/(getT(lv) - getZ(lv)))


#######################
# spherical coordinates
#######################

"""Function alias for [`getMagnitude2`](@ref)"""
const getRho2 = getMagnitude2
"""Function alias for [`getMagnitude`](@ref)"""
const getRho = getMagnitude 

"""

    getTheta(lv)

Return the theta angle for a given `LorentzVectorLike`, i.e. the polar angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike` with magnitude `rho`, this is equivalent to `arccos(pz/rho)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis. 

"""
@inline @traitfn function getTheta(lv::T)  where {T; IsLorentzVectorLike{T}}
    getX(lv)==zero(getX(lv)) && getY(lv)==zero(getY(lv)) && getZ(lv)==zero(getZ(lv)) ? zero(getX(lv)) : atan(getTransverseMomentum(lv),getZ(lv))
end

"""

    getCosTheta(lv)

Return the cosine of the theta angle for a given `LorentzVectorLike`.

!!! note 

    This is an equivalent but faster version of `cos(getTheta(lv))`; see [`getTheta`](@ref).

"""
@traitfn function getCosTheta(lv::T)  where {T; IsLorentzVectorLike{T}}
    r = getRho(lv)
    r==zero(getX(lv)) ? one(getX(lv)) : getZ(lv)/r
end

"""

    getPhi(lv)

Return the phi angle for a given `LorentzVectorLike`, i.e. the azimuthal angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `atan(py,px)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis. 

"""
@traitfn function getPhi(lv::T)  where {T; IsLorentzVectorLike{T}}
    n = zero(getX(lv))
    getX(lv)==n && getY(lv)==n ? n : atan(getY(lv),getX(lv))
end

"""

    getCosPhi(lv)

Return the cosine of the phi angle for a given `LorentzVectorLike`.

!!! note 

    This is an equivalent but faster version of `cos(getPhi(lv))`; see [`getPhi`](@ref).

"""
@traitfn function getCosPhi(lv::T)  where {T; IsLorentzVectorLike{T}}
    perp = getPerp(lv)
    perp==zero(perp) ? one(perp) : getX(lv)/perp
end

"""

    getSinPhi(lv)

Return the sin of the phi angle for a given `LorentzVectorLike`.

!!! note 

    This is an equivalent but faster version of `sin(getPhi(lv))`; see [`getPhi`](@ref).

"""
@traitfn function getSinPhi(lv::T)  where {T; IsLorentzVectorLike{T}}
    perp = getPerp(lv)
    perp==zero(perp) ? sin(perp) : getY(lv)/perp
end


########################
# light cone coordinates
########################
"""

    getPlus(lv)

Return the plus component for a given `LorentzVectorLike` in [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates).

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `(E+pz)/2`.

!!! note

    The [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) are defined w.r.t. to the 3-axis.
    
!!! warning

    The definition ``p^+ := (E + p_z)/2` differs from the usual definition of [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) in general relativity.

"""
@inline @traitfn getPlus(lv::T)  where {T; IsLorentzVectorLike{T}} = 0.5*(getT(lv) + getZ(lv))

"""

    getMinus(lv)

Return the minus component for a given `LorentzVectorLike` in [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates).

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `(E-pz)/2`.

!!! note

    The [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) are defined w.r.t. to the 3-axis.
    
!!! warning

    The definition ``p^- := (E - p_z)/2` differs from the usual definition of [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) in general relativity.

"""
@inline @traitfn getMinus(lv::T)  where {T; IsLorentzVectorLike{T}} = 0.5*(getT(lv) - getZ(lv))


####
#
# Setter
#
####

"""

    setE!(lv,value)

Sets the energy component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setE!` is then returned by [`getE`](@ref).

"""
@inline @traitfn setE!(lv::T,value::VT)  where {T,VT; IsMutableLorentzVectorLike{T}} =  setT!(lv,value)
"""Function alias for [`setE!`](@ref)."""
const setEnergy! = setE!

"""

    setPx!(lv,value)

Sets the 1-component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setPx!` is then returned by [`getPx`](@ref).

"""
@inline @traitfn setPx!(lv::T,value::VT)  where {T,VT; IsMutableLorentzVectorLike{T}} =  setX!(lv,value)

"""

    setPy!(lv,value)

Sets the 2-component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setPy!` is then returned by [`getPy`](@ref).

"""
@inline @traitfn setPy!(lv::T,value::VT)  where {T,VT; IsMutableLorentzVectorLike{T}} =  setY!(lv,value)

"""

    setPz!(lv,value)

Sets the 3-component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setPz!` is then returned by [`getPz`](@ref).

"""
@inline @traitfn setPz!(lv::T,value::VT)  where {T,VT; IsMutableLorentzVectorLike{T}} =  setZ!(lv,value)

# setter spherical coordinates

"""

    setTheta!(lv,value)

Sets the theta angle of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setTheta!` is then returned by [`getTheta`](@ref). Since the theta angle is computed on the call of `getTheta`, the setter `setTheta!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setTheta!(lv::T,theta::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    rho = getRho(lv)
    sphi = getSinPhi(lv)
    cphi = getCosPhi(lv)
    sth = sin(theta)

    setX!(lv,rho*sth*cphi)
    setY!(lv,rho*sth*sphi)
    setZ!(lv,rho*cos(theta))
    return 
end

"""

    setCosTheta!(lv,value)

Sets the cosine of the theta angle of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setCosTheta!` is then returned by [`getCosTheta`](@ref). Since the cosine of the theta angle is computed on the call of `getCosTheta`, the setter `setCosTheta!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setCosTheta!(lv::T,cos_theta::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    rho = getRho(lv)
    sphi = getSinPhi(lv)
    cphi = getCosPhi(lv)
    sth = sqrt(one(cos_theta)-cos_theta^2)

    setX!(lv,rho*sth*cphi)
    setY!(lv,rho*sth*sphi)
    setZ!(lv,rho*cos_theta)
    return 
end

"""

    setPhi!(lv,value)

Sets the phi angle of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setPhi!` is then returned by [`getPhi`](@ref). Since the phi angle is computed on the call of `getPhi`, the setter `setPhi!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setPhi!(lv::T,phi::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    rho = getRho(lv)
    sphi = sin(phi)
    cphi = cos(phi)
    cth = getCosTheta(lv)
    sth = sqrt(one(cth)-cth^2)

    setX!(lv,rho*sth*cphi)
    setY!(lv,rho*sth*sphi)
    setZ!(lv,rho*cth)
    return 
end

"""

    setRho!(lv,value)

Sets the magnitude of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setRho!` is then returned by [`getRho`](@ref). Since the magnitude is computed on the call of `getRho`, the setter `setRho!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setRho!(lv::T,rho::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    rho2 = getRho(lv)
    if rho2 != zero(rho2)
        setX!(lv,getX(lv)*rho/rho2)
        setY!(lv,getY(lv)*rho/rho2)
        setZ!(lv,getZ(lv)*rho/rho2)
    end
    # add warning if rho2 == 0 -> zero vector does not change if its length is stretched.
    return 
end


# setter light cone coordinates


"""

    setPlus!(lv,value)

Sets the plus component of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setPlus!` is then returned by [`getPlus`](@ref). Since the plus component is computed on the call of `getPlus`, the setter `setPlus!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setPlus!(lv::T,plus::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    old_pminus = getMinus(lv)
    setT!(lv,plus + old_pminus)
    setZ!(lv,plus - old_pminus)
    return 
end

"""

    setMinus!(lv,value)

Sets the minus component of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setMinus!` is then returned by [`getMinus`](@ref). Since the minus component is computed on the call of `getMinus`, the setter `setMinus!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setMinus!(lv::T,minus::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    old_pplus = getPlus(lv)
    setT!(lv,old_pplus + minus)
    setZ!(lv,old_pplus - minus)
    return 
end


# transverse coordinates
"""

    setTransverseMomentum!(lv,value)

Sets the transverse momentum of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setTransverseMomentum!` is then returned by [`getTransverseMomentum`](@ref). Since the transverse momentum is computed on the call of `getTransverseMomentum`, the setter `setTransverseMomentum!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setTransverseMomentum!(lv::T,pT::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    old_pT = getTransverseMomentum(lv)
    if old_pT != zero(old_pT)
        setX!(lv,getX(lv)*pT/old_pT)
        setY!(lv,getY(lv)*pT/old_pT)
    end
    # add warning if old_pert == 0 -> vector with vanishing pert components does not change if its length is stretched transversally.
    return 
end
"""Function alias for [`setTransverseMomentum!`](@ref)."""
const setPerp! = setTransverseMomentum!
"""Function alias for [`setTransverseMomentum!`](@ref)."""
const setPt! = setTransverseMomentum!

"""

    setTransverseMass!(lv,value)

Sets the transverse mass of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setTransverseMass!` is then returned by [`getTransverseMass`](@ref). Since the transverse mass is computed on the call of `getTransverseMass`, the setter `setTransverseMass!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setTransverseMass!(lv::T,mT::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    old_mT = getTransverseMass(lv)
    if old_mT != zero(old_mT)
        setT!(lv,getT(lv)*mT/old_mT)
        setZ!(lv,getZ(lv)*mT/old_mT)
    end
    # add warning if old_pert == 0 -> vector with vanishing pert components does not change if its length is stretched transversally.
    return 
end
"""Function alias for [`setTransverseMass!`](@ref)."""
const setMt! = setTransverseMass!

"""

    setRapidity!(lv,value)

Sets the rapidity of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` setted with `setRapidity!` is then returned by [`setRapidity`](@ref). Since the rapidity is computed on the call of `setRapidity`, the setter `setRapidity!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setRapidity!(lv::T,rap::VT)  where {T,VT; IsMutableLorentzVectorLike{T}}
    mT = getTransverseMass(lv)
    setT!(lv,mT*cosh(rap))
    setZ!(lv,mT*sinh(rap))
    # add warning if old_pert == 0 -> vector with vanishing pert components does not change if its length is stretched transversally.
    return 
end

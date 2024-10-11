import Base: *

function dot(p1::T1, p2::T2) where {T1<:AbstractLorentzVector,T2<:AbstractLorentzVector}
    return mdot(p1, p2)
end
@inline function *(
    p1::T1, p2::T2
) where {T1<:AbstractLorentzVector,T2<:AbstractLorentzVector}
    return dot(p1, p2)
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

    We use the mostly minus metric.

"""
@inline @traitfn function minkowski_dot(
    x1::T1, x2::T2
) where {T1,T2;IsLorentzVectorLike{T1}, IsLorentzVectorLike{T2}}
    return getT(x1) * getT(x2) -
           (getX(x1) * getX(x2) + getY(x1) * getY(x2) + getZ(x1) * getZ(x2))
end

"""
Function alias for [`minkowski_dot`](@ref).
"""
const mdot = minkowski_dot

"""
    getMagnitude2(lv)

Return the square of the magnitude of a given `LorentzVectorLike`, i.e. the sum of the squared spatial components. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `x^2+ y^2 + z^2`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline @traitfn function getMagnitude2(lv::T) where {T; IsLorentzVectorLike{T}}
    return getX(lv)^2 + getY(lv)^2 + getZ(lv)^2
end

"""
Functiom alias for [`getMagnitude2`](@ref).
"""
const getMag2 = getMagnitude2

"""
    getMagnitude(lv)

Return the magnitude of a given `LorentzVectorLike`, i.e. the euklidian norm spatial components. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `sqrt(x^2 + y^2 + z^2)`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline @traitfn function getMagnitude(lv::T) where {T; IsLorentzVectorLike{T}}
    # assume nothrow since getMagnitude2 always returns a positive result
    Base.@assume_effects :nothrow
    return sqrt(getMagnitude2(lv))
end

"""
Functiom alias for [`getMagnitude`](@ref).
"""
const getMag = getMagnitude

"""
    getInvariantMass2(lv)

Return the squared invariant mass of a given `LorentzVectorLike`, i.e. the minkowski dot with itself. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `t^2 - (x^2 + y^2 + z^2)`. 


"""
@inline @traitfn function getInvariantMass2(lv::T) where {T; IsLorentzVectorLike{T}}
    return minkowski_dot(lv, lv)
end

"""Function alias for [`getInvariantMass2`](@ref)"""
const getMass2 = getInvariantMass2

"""
    getInvariantMass(lv)

Return the the invariant mass of a given `LorentzVectorLike`, i.e. the square root of the minkowski dot with itself. 

!!! example 

    If `(t,x,y,z)` is a `LorentzVectorLike`, this is equivalent to `sqrt(t^2 - (x^2 + y^2 + z^2))`.


!!! note
    
    If the squared invariant mass `m2` is negative, `-sqrt(-m2)` is returned. 

"""
@traitfn function getInvariantMass(lv::T) where {T; IsLorentzVectorLike{T}}
    # assume nothrow since we make sure that sqrt is only called on positive values
    Base.@assume_effects :nothrow
    m2 = getInvariantMass2(lv)
    if m2 < zero(m2)
        # Think about including this warning, maybe optional with a global PRINT_WARNINGS switch.
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
@inline @traitfn getE(lv::T) where {T; IsLorentzVectorLike{T}} = getT(lv)

"""Function alias for [`getE`](@ref)."""
const getEnergy = getE

"""
    getPx(lv)

Return the ``p_x`` component of a given `LorentzVectorLike`, i.e. its 1-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `px`.

"""
@inline @traitfn getPx(lv::T) where {T; IsLorentzVectorLike{T}} = getX(lv)

"""
    getPy(lv)

Return the ``p_y`` component of a given `LorentzVectorLike`, i.e. its 2-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `py`.

"""
@inline @traitfn getPy(lv::T) where {T; IsLorentzVectorLike{T}} = getY(lv)

"""
    getPz(lv)

Return the ``p_z`` component of a given `LorentzVectorLike`, i.e. its 3-component. 

!!! example 

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `pz`.

"""
@inline @traitfn getPz(lv::T) where {T; IsLorentzVectorLike{T}} = getZ(lv)

"""
    getBeta(lv)

Return magnitude of the beta vector for a given `LorentzVectorLike`, i.e. the magnitude of the `LorentzVectorLike` divided by its 0-component.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `sqrt(px^2 + py^2 + pz^2)/E`.

"""
@inline @traitfn function getBeta(lv::T) where {T; IsLorentzVectorLike{T}}
    if getT(lv) != zero(getT(lv))
        getRho(lv) / getT(lv)
    elseif getRho(lv) == zero(getT(lv))
        return zero(getT(lv))
    else
        throw(
            error(
                "There is no beta for a LorentzVectorLike with vanishing time/energy component",
            ),
        )
    end
end

"""
    getGamma(lv)

Return the relativistic gamma factor for a given `LorentzVectorLike`, i.e. the inverse square root of one minus the beta vector squared.

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike` with beta vector `β`, this is equivalent to `1/sqrt(1- β^2)`.

"""
@inline @traitfn function getGamma(lv::T) where {T; IsLorentzVectorLike{T}}
    return inv(sqrt(one(getT(lv)) - getBeta(lv)^2))
end

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
@inline @traitfn function getTransverseMomentum2(lv::T) where {T; IsLorentzVectorLike{T}}
    return getX(lv)^2 + getY(lv)^2
end

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
@inline @traitfn function getTransverseMomentum(lv::T) where {T; IsLorentzVectorLike{T}}
    # getTransverseMomentum2 always returns a positive value, therefore we can assume :nothrow
    Base.@assume_effects :nothrow
    return sqrt(getTransverseMomentum2(lv))
end
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
@inline @traitfn function getTransverseMass2(lv::T) where {T; IsLorentzVectorLike{T}}
    return getT(lv)^2 - getZ(lv)^2
end
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
@traitfn function getTransverseMass(lv::T) where {T; IsLorentzVectorLike{T}}
    # sqrt is only called on positive numbers, therefore we can assume nothrow
    Base.@assume_effects :nothrow
    mT2 = getTransverseMass2(lv)
    if mT2 < zero(mT2)
        # add optional warning: negative transverse mass -> -sqrt(-mT2) is returned.
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

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `0.5*log((E+pz)/(E-pz))`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis. 

"""
@inline @traitfn function getRapidity(lv::T) where {T; IsLorentzVectorLike{T}}
    return 0.5 * log((getT(lv) + getZ(lv)) / (getT(lv) - getZ(lv)))
end

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

    If `(E,px,py,pz)` is a `LorentzVectorLike` with magnitude `rho`, this is equivalent to `arccos(pz/rho)`, which is also equivalent to `arctan(sqrt(px^2+py^2)/pz)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis. 

"""
@inline @traitfn function getTheta(lv::T) where {T; IsLorentzVectorLike{T}}
    return if getX(lv) == zero(getX(lv)) &&
        getY(lv) == zero(getY(lv)) &&
        getZ(lv) == zero(getZ(lv))
        zero(getX(lv))
    else
        atan(getTransverseMomentum(lv), getZ(lv))
    end
end

"""
    getCosTheta(lv)

Return the cosine of the theta angle for a given `LorentzVectorLike`.

!!! note 

    This is an equivalent but faster version of `cos(getTheta(lv))`; see [`getTheta`](@ref).

"""
@traitfn function getCosTheta(lv::T) where {T; IsLorentzVectorLike{T}}
    r = getRho(lv)
    return r == zero(getX(lv)) ? one(getX(lv)) : getZ(lv) / r
end

"""
    getPhi(lv)

Return the phi angle for a given `LorentzVectorLike`, i.e. the azimuthal angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).

!!! example

    If `(E,px,py,pz)` is a `LorentzVectorLike`, this is equivalent to `atan(py,px)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis. 

"""
@traitfn function getPhi(lv::T) where {T; IsLorentzVectorLike{T}}
    n = zero(getX(lv))
    return getX(lv) == n && getY(lv) == n ? n : atan(getY(lv), getX(lv))
end

"""
    getCosPhi(lv)

Return the cosine of the phi angle for a given `LorentzVectorLike`.

!!! note 

    This is an equivalent but faster version of `cos(getPhi(lv))`; see [`getPhi`](@ref).

"""
@traitfn function getCosPhi(lv::T) where {T; IsLorentzVectorLike{T}}
    perp = getPerp(lv)
    return perp == zero(perp) ? one(perp) : getX(lv) / perp
end

"""
    getSinPhi(lv)

Return the sine of the phi angle for a given `LorentzVectorLike`.

!!! note 

    This is an equivalent but faster version of `sin(getPhi(lv))`; see [`getPhi`](@ref).

"""
@traitfn function getSinPhi(lv::T) where {T; IsLorentzVectorLike{T}}
    perp = getPerp(lv)
    return perp == zero(perp) ? sin(perp) : getY(lv) / perp
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
@inline @traitfn function getPlus(lv::T) where {T; IsLorentzVectorLike{T}}
    return 0.5 * (getT(lv) + getZ(lv))
end

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
@inline @traitfn function getMinus(lv::T) where {T; IsLorentzVectorLike{T}}
    return 0.5 * (getT(lv) - getZ(lv))
end

####
#
# Setter
#
####

"""
    setE!(lv,value)

Sets the energy component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setE!` is then returned by [`getE`](@ref).

"""
@inline @traitfn function setE!(lv::T, value::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    return setT!(lv, value)
end
"""Function alias for [`setE!`](@ref)."""
const setEnergy! = setE!

"""
    setPx!(lv,value)

Sets the 1-component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setPx!` is then returned by [`getPx`](@ref).

"""
@inline @traitfn function setPx!(
    lv::T, value::VT
) where {T,VT;IsMutableLorentzVectorLike{T}}
    return setX!(lv, value)
end

"""
    setPy!(lv,value)

Sets the 2-component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setPy!` is then returned by [`getPy`](@ref).

"""
@inline @traitfn function setPy!(
    lv::T, value::VT
) where {T,VT;IsMutableLorentzVectorLike{T}}
    return setY!(lv, value)
end

"""
    setPz!(lv,value)

Sets the 3-component of a given `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setPz!` is then returned by [`getPz`](@ref).

"""
@inline @traitfn function setPz!(
    lv::T, value::VT
) where {T,VT;IsMutableLorentzVectorLike{T}}
    return setZ!(lv, value)
end

# setter spherical coordinates

"""
    setTheta!(lv,value)

Sets the theta angle of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setTheta!` is then returned by [`getTheta`](@ref). Since the theta angle is computed on the call of `getTheta`, the setter `setTheta!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setTheta!(lv::T, theta::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    rho = getRho(lv)
    sphi = getSinPhi(lv)
    cphi = getCosPhi(lv)
    sth = sin(theta)

    setX!(lv, rho * sth * cphi)
    setY!(lv, rho * sth * sphi)
    setZ!(lv, rho * cos(theta))
    return nothing
end

"""
    setCosTheta!(lv,value)

Sets the cosine of the theta angle of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setCosTheta!` is then returned by [`getCosTheta`](@ref). Since the cosine of the theta angle is computed on the call of `getCosTheta`, the setter `setCosTheta!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setCosTheta!(
    lv::T, cos_theta::VT
) where {T,VT;IsMutableLorentzVectorLike{T}}
    rho = getRho(lv)
    sphi = getSinPhi(lv)
    cphi = getCosPhi(lv)
    sth = sqrt(one(cos_theta) - cos_theta^2)

    setX!(lv, rho * sth * cphi)
    setY!(lv, rho * sth * sphi)
    setZ!(lv, rho * cos_theta)
    return nothing
end

"""
    setPhi!(lv,value)

Sets the phi angle of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setPhi!` is then returned by [`getPhi`](@ref). Since the phi angle is computed on the call of `getPhi`, the setter `setPhi!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setPhi!(lv::T, phi::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    rho = getRho(lv)
    sphi = sin(phi)
    cphi = cos(phi)
    cth = getCosTheta(lv)
    sth = sqrt(one(cth) - cth^2)

    setX!(lv, rho * sth * cphi)
    setY!(lv, rho * sth * sphi)
    setZ!(lv, rho * cth)
    return nothing
end

"""
    setRho!(lv,value)

Sets the magnitude of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setRho!` is then returned by [`getRho`](@ref). Since the magnitude is computed on the call of `getRho`, the setter `setRho!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setRho!(lv::T, rho::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    rho2 = getRho(lv)
    if rho2 != zero(rho2)
        setX!(lv, getX(lv) * rho / rho2)
        setY!(lv, getY(lv) * rho / rho2)
        setZ!(lv, getZ(lv) * rho / rho2)
    end
    # add warning if rho2 == 0 -> zero vector does not change if its length is stretched.
    return nothing
end

# setter light cone coordinates

"""
    setPlus!(lv,value)

Sets the plus component of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setPlus!` is then returned by [`getPlus`](@ref). Since the plus component is computed on the call of `getPlus`, the setter `setPlus!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setPlus!(lv::T, plus::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    old_pminus = getMinus(lv)
    setT!(lv, plus + old_pminus)
    setZ!(lv, plus - old_pminus)
    return nothing
end

"""
    setMinus!(lv,value)

Sets the minus component of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setMinus!` is then returned by [`getMinus`](@ref). Since the minus component is computed on the call of `getMinus`, the setter `setMinus!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setMinus!(lv::T, minus::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    old_pplus = getPlus(lv)
    setT!(lv, old_pplus + minus)
    setZ!(lv, old_pplus - minus)
    return nothing
end

# transverse coordinates
"""
    setTransverseMomentum!(lv,value)

Sets the transverse momentum of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setTransverseMomentum!` is then returned by [`getTransverseMomentum`](@ref). Since the transverse momentum is computed on the call of `getTransverseMomentum`, the setter `setTransverseMomentum!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setTransverseMomentum!(
    lv::T, pT::VT
) where {T,VT;IsMutableLorentzVectorLike{T}}
    old_pT = getTransverseMomentum(lv)
    if old_pT != zero(old_pT)
        setX!(lv, getX(lv) * pT / old_pT)
        setY!(lv, getY(lv) * pT / old_pT)
    end
    # add warning if old_pert == 0 -> vector with vanishing pert components does not change if its length is stretched transversally.
    return nothing
end
"""Function alias for [`setTransverseMomentum!`](@ref)."""
const setPerp! = setTransverseMomentum!
"""Function alias for [`setTransverseMomentum!`](@ref)."""
const setPt! = setTransverseMomentum!

"""
    setTransverseMass!(lv,value)

Sets the transverse mass of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setTransverseMass!` is then returned by [`getTransverseMass`](@ref). Since the transverse mass is computed on the call of `getTransverseMass`, the setter `setTransverseMass!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setTransverseMass!(
    lv::T, mT::VT
) where {T,VT;IsMutableLorentzVectorLike{T}}
    old_mT = getTransverseMass(lv)
    if old_mT != zero(old_mT)
        setT!(lv, getT(lv) * mT / old_mT)
        setZ!(lv, getZ(lv) * mT / old_mT)
    end
    # add warning if old_pert == 0 -> vector with vanishing pert components does not change if its length is stretched transversally.
    return nothing
end
"""Function alias for [`setTransverseMass!`](@ref)."""
const setMt! = setTransverseMass!

"""
    setRapidity!(lv,value)

Sets the rapidity of a `LorentzVectorLike` to a given `value`.

!!! note

    The `value` set with `setRapidity!` is then returned by [`getRapidity`](@ref). Since the rapidity is computed on the call of `setRapidity`, the setter `setRapidity!` changes several components of the given `LorentzVectorLike`.

"""
@traitfn function setRapidity!(lv::T, rap::VT) where {T,VT;IsMutableLorentzVectorLike{T}}
    mT = getTransverseMass(lv)
    setT!(lv, mT * cosh(rap))
    setZ!(lv, mT * sinh(rap))
    # add warning if old_pert == 0 -> vector with vanishing pert components does not change if its length is stretched transversally.
    return nothing
end

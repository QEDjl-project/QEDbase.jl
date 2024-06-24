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

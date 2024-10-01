# Lorentz Vector API

## Interface registry

```@docs
register_LorentzVectorLike
```

## Built-in Lorentz vector types

```@docs
AbstractLorentzVector
AbstractFourMomentum
```

## Accessor functions

```@docs
minkowski_dot
mdot
getT
getX
getY
getZ
getMagnitude2
getMag2
getMagnitude
getMag

getInvariantMass2
getMass2
getInvariantMass
getMass
getE
getEnergy
getPx
getPy
getPz
getBeta
getGamma

getTransverseMomentum2
getPt2
getPerp2
getTransverseMomentum
getPt
getPerp
getTransverseMass2
getMt2
getTransverseMass
getMt
getRapidity

getRho2
getRho
getTheta
getCosTheta
getPhi
getCosPhi
getSinPhi
getPlus
getMinus
```

## Setter functions

```@docs
setE!
setEnergy!
setPx!
setPy!
setPz!
setTheta!
setCosTheta!
setRho!
setPhi!
setPlus!
setMinus!

setTransverseMomentum!
setPerp!
setPt!
setTransverseMass!
setMt!
setRapidity!
```

## Utilities

```@docs
isonshell
assert_onshell
```

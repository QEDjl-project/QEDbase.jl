# Four Momenta

Within QEDbase, we model four-momenta with a specialized LorentzVector, where the components are forced to be float:

``` Julia
    FourMomentum <:AbstractLorentzVector{::Float64}
```

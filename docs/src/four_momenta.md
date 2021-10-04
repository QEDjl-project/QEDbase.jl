# Four Momenta

Within HEPbase, we model four-momenta with a specialized LorentzVector, where the components are forced to be float:

    FourMomentum <:AbstractLorentzVector{::Float64}

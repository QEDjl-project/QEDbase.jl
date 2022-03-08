
using QEDbase
using StaticArrays
using BenchmarkTools


p = SLorentzVector(1,1,1,1)
p2 = SLorentzVector(1.0,0,0,2.0)
p3 = SLorentzVector(1.0,0,0,2.0)

@benchmark mdot($p3,$p2)

@benchmark mdot($p,$p2)

p*p2

p*2


mP = MLorentzVector(1.0,1,1,1)


@benchmark mdot($mP,$p)

mP*2.0

p*mP

#mdot(p,mP)

function Base.promote_rule(::Type{MLorentzVector{T}},::Type{LV}) where {T,LV<:AbstractLorentzVector{S}} where S
    MLorentzVector{promote_type(T,S)}
end

promote(mP,p2) # error: 



p*2
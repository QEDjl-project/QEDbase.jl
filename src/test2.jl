
using QEDbase
using StaticArrays
using BenchmarkTools


p = SLorentzVector(1.0,1,1,1)
p2 = SLorentzVector(1.0,0,0,2.0)


mP = QEDbase.MLorentzVector(1.0,1,1,1)



QEDbase.setX!(mP,2.2)

mP

struct CustomType{T} <: FieldArray{2,T}
    x::T
    y::T
end
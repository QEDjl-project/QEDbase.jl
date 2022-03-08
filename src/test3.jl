

using QEDbase
using StaticArrays
using BenchmarkTools



num = 2.0
LV1 = MLorentzVector(1,2,3,4)
LV2 = SLorentzVector(4,3,2,1)
num_cmplx = 1.0+1.0im

LV1*num_cmplx

LV2*num_cmplx

num_cmplx*LV2
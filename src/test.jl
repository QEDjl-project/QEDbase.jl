using Random
using QEDbase


rng = MersenneTwister(123456)

x,y,z = 0,0,2#rand(rng,3)
mass = 0.0 #rand(rng)
E = sqrt(x^2 + y^2 + z^2 + mass^2)
mom = MFourMomentum(E,x,y,z)

I = getRapidity(mom)


I === Inf
I==Inf64

typeof(Inf)

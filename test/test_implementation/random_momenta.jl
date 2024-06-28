
"""
Return a tuple of random four momenta, i.e. a random phase space point.
"""
function _rand_momenta(rng::AbstractRNG, n)
    return NTuple{n,SFourMomentum}(SFourMomentum(rand(rng, 4)) for _ in 1:n)
end

"""
Return a vector of tuples of random four momenta, i.e. a collection of phase space points.
n1 is the size of the phase space point, n2 is the number of points.
"""
function _rand_momenta(rng::AbstractRNG, n1, n2)
    moms = Vector{NTuple{n1,SFourMomentum}}(undef, n2)
    for i in 1:n2
        moms[i] = _rand_momenta(rng, n1)
    end
    return moms
end

"""
Return a random phase space point that is failing the incoming phase space constraint,
i.e. the first entry of the phase space is the null momentum.
"""
function _rand_in_momenta_failing(rng::AbstractRNG, n)
    return (zero(SFourMomentum), _rand_momenta(rng, n - 1)...)
end

"""
Return a random phase space point that is failing the outgoing phase space constraint,
i.e. the last entry of the phase space is the unit momentum.
"""
function _rand_out_momenta_failing(rng::AbstractRNG, n)
    return (_rand_momenta(rng, n - 1)..., ones(SFourMomentum))
end

"""
Return a collection of incoming phase space points, where the first point is failing the phase space constraint,
i.e. the first entry of the vector is invalid but the others pass.
n1 is the size of the phase space point, n2 is the number of points.
"""
function _rand_in_momenta_failing_mix(rng::AbstractRNG, n1, n2)
    moms = _rand_momenta(rng, n1, n2)
    moms[1] = _rand_in_momenta_failing(rng, n1)
    return moms
end

"""
Return a collection of incoming phase space points, where all points are failing the phase space constraint,
i.e. their first entries are null momenta.
n1 is the size of the phase space point, n2 is the number of points.
"""
function _rand_in_momenta_failing_all(rng::AbstractRNG, n1, n2)
    moms = Vector{NTuple{n1,SFourMomentum}}(undef, n2)
    for i in 1:n2
        moms[i] = _rand_in_momenta_failing(rng, n1)
    end
    return moms
end

"""
Return a vector of outgoing phase space points, where the first point is failing the phase space constraint,
i.e. the last entry of the vector is invalid but the others pass.
n1 is the size of the phase space point, n2 is the number of points.
"""
function _rand_out_momenta_failing_mix(rng::AbstractRNG, n1, n2)
    moms = _rand_momenta(rng, n1, n2)
    moms[end] = _rand_out_momenta_failing(rng, n1)
    return moms
end

"""
Return a vector of outgoing phase space points, where all points are failing the phase space constraint,
i.e. their last entries are unit momenta.
n1 is the size of the phase space point, n2 is the number of points.
"""
function _rand_out_momenta_failing_all(rng::AbstractRNG, n1, n2)
    moms = Vector{NTuple{n1,SFourMomentum}}(undef, n2)
    for i in 1:n2
        moms[i] = _rand_out_momenta_failing(rng, n1)
    end
    return moms
end

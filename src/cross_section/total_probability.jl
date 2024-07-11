###########
# Total probability
###########

"""
    total_probability(in_psp::AbstractInPhaseSpacePoint)

Return the total probability of a given [`AbstractInPhaseSpacePoint`](@ref).
"""
function total_probability(in_psp::AbstractInPhaseSpacePoint)
    return _total_probability(in_psp)
end

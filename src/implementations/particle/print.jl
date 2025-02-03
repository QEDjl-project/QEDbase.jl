
# generic show for abstract particle types
function Base.show(io::IO, particle::T) where {T<:AbstractParticleType}
    t_string = string(nameof(T))
    lc_name = join(lowercase.(_split_uppercase(t_string)), " ")

    print(io, "$(lc_name)")
    return nothing
end

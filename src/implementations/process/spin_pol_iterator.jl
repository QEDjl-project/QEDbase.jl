"""
    SpinPolIter

An iterator type to iterate over spin and polarization combinations. Should be used through [`spin_pols_iter`](@ref).
"""
struct SpinPolIter{I,O}
    # product iterator doing the actual iterating
    product_iter::Base.Iterators.ProductIterator
    # lookup table for which indices go where, translating the base iterator to the actual result
    indexing_lut::Tuple{NTuple{I,Int},NTuple{O,Int}}
end


# FIXME: the example should be jldoctests, but they are currently broken
"""
    all_spin_pols(process::AbstractProcessDefinition)

This function returns an iterator, yielding every fully definite combination of spins and polarizations allowed by the
process' [`spin_pols`](@ref). Each returned element is a Tuple of the incoming and the outgoing spins and polarizations,
in the order of the process' own spins and polarizations.

This works together with the definite spins and polarizations, [`AllSpin`](@ref), [`AllPolarization`](@ref), and the synced versions
[`SyncedPolarization`](@ref) and [`SyncedSpin`](@ref).

```Julia
julia> using QEDbase; using QEDcore; using QEDprocesses;

julia> proc = ScatteringProcess((Photon(), Photon(), Photon(), Electron()), (Photon(), Electron()), (SyncedPolarization(1), SyncedPolarization(2), SyncedPolarization(1), SpinUp()), (SyncedPolarization(2), AllSpin()))
generic QED process
    incoming: photon (synced polarization 1), photon (synced polarization 2), photon (synced polarization 1), electron (spin up)
    outgoing: photon (synced polarization 2), electron (all spins)


julia> for sp_combo in spin_pols_iter(proc) println(sp_combo) end
((x-polarized, x-polarized, x-polarized, spin up), (x-polarized, spin up))
((y-polarized, x-polarized, y-polarized, spin up), (x-polarized, spin up))
((x-polarized, y-polarized, x-polarized, spin up), (y-polarized, spin up))
((y-polarized, y-polarized, y-polarized, spin up), (y-polarized, spin up))
((x-polarized, x-polarized, x-polarized, spin up), (x-polarized, spin down))
((y-polarized, x-polarized, y-polarized, spin up), (x-polarized, spin down))
((x-polarized, y-polarized, x-polarized, spin up), (y-polarized, spin down))
((y-polarized, y-polarized, y-polarized, spin up), (y-polarized, spin down))

julia> length(spin_pols_iter(proc))
8
```
"""
function spin_pols_iter(process::AbstractProcessDefinition)
    DEF_SPINS = (SpinUp(), SpinDown())
    DEF_POLS = (PolX(), PolY())

    in_sp = incoming_spin_pols(process)
    I = length(in_sp)
    out_sp = outgoing_spin_pols(process)
    O = length(out_sp)

    # concatenate for now for easier indices, split again later
    sps = (in_sp..., out_sp...)

    # keep indices of first seen SyncedSpins or SyncedPols
    synced_seen = Dict{AbstractSpinOrPolarization,Int}()
    index = 0
    for sp in sps
        index += 1
        if !(sp isa SyncedSpin || sp isa SyncedPolarization)
            continue
        end
        if !haskey(synced_seen, sp)
            synced_seen[sp] = index
        end
    end

    # keep indices of the synced spins/pols in the iterator (not necessarily the same as synced_seen)
    synced_indices = Dict{AbstractSpinOrPolarization,Int}()

    iter_tuples = Vector()
    lut = Vector{Int}()
    index = 0
    for sp in sps
        index += 1
        if sp isa AbstractDefiniteSpin || sp isa AbstractDefinitePolarization
            push!(iter_tuples, (sp,))
            push!(lut, length(iter_tuples))
        elseif sp isa SyncedSpin
            # check if it's the first synced
            if index == synced_seen[sp]
                push!(iter_tuples, DEF_SPINS)
                synced_indices[sp] = length(iter_tuples)
            end
            push!(lut, synced_indices[sp])
        elseif sp isa SyncedPolarization
            if index == synced_seen[sp]
                push!(iter_tuples, DEF_POLS)
                synced_indices[sp] = length(iter_tuples)
            end
            push!(lut, synced_indices[sp])
        elseif sp isa AllSpin
            push!(iter_tuples, DEF_SPINS)
            push!(lut, length(iter_tuples))
        elseif sp isa AllPol
            push!(iter_tuples, DEF_POLS)
            push!(lut, length(iter_tuples))
        end
    end

    return SpinPolIter(
        Iterators.product(iter_tuples...),
        (tuple(lut[begin:I]...), tuple(lut[(I + 1):end]...)),
    )
end

function Base.iterate(iterator::SpinPolIter, state=nothing)
    local prod_iter_res
    if isnothing(state)
        prod_iter_res = iterate(iterator.product_iter)
    else
        prod_iter_res = iterate(iterator.product_iter, state)
    end

    if isnothing(prod_iter_res)
        return nothing
    end
    prod_iter_res, state = prod_iter_res

    # translate prod_iter_res into actual result
    in_t = ((prod_iter_res[i] for i in iterator.indexing_lut[1])...,)
    out_t = ((prod_iter_res[i] for i in iterator.indexing_lut[2])...,)

    return (in_t, out_t), state
end

function Base.length(iterator::SpinPolIter)
    return length(iterator.product_iter)
end

_check_phase_space_dimension(::Val{N}, out_coords::NTuple{N}) where {N} = nothing
function _check_phase_space_dimension(
        ::Val{Nin}, ::Val{Nout}, in_coords::NTuple{Nin}, out_coords::NTuple{Nout}
    ) where {Nin, Nout}
    return nothing
end

function _check_phase_space_dimension(::Val{Nc}, out_coords::NTuple{N}) where {Nc, N}
    throw(
        InvalidInputError(
            "number of coordinates <$N> must be the same as the out-phase-space dimension <$Nc>",
        ),
    )
end

function _check_phase_space_dimension(
        ::Val{Ncin}, ::Val{Ncout}, in_coords::NTuple{N1}, out_coords::NTuple{N2}
    ) where {Ncin, Ncout, N1, N2}
    err_msg = ""

    if Ncin != N1
        err_msg =
            err_msg *
            "number of in coordinates <$N1> must be the same as the in-phase-space dimension <$Ncin>\n"
    end

    if Ncout != N2
        err_msg =
            err_msg *
            "number of out coordinates <$N2> must be the same as the out-phase-space dimension <$Ncout>"
    end

    throw(InvalidInputError(err_msg))
end

_check_number_of_momenta(::Val{N}, moms::NTuple{N}) where {N} = nothing
function _check_number_of_momenta(::Val{Nin}, moms::NTuple{N}) where {Nin, N}
    throw(
        InvalidInputError(
            "number of in momenta <$N> must be the same as the number of incoming particles<$Nin>",
        ),
    )
end

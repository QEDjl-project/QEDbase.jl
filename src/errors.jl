struct OnshellError{M,T} <: Exception
    mom::M
    mass::T
end

function Base.showerror(io::IO, e::OnshellError)
    return print(
        io,
        "OnshellError: The momentum $(e.mom) is not onshell w.r.t. the mass $(e.mass).\n mom*mom = $(e.mom*e.mom)",
    )
end

"""
$(TYPEDEF)

Exception raised, if a certain type `target_type` can not be registed for a certain interface, since there needs the function `func` to be impleemnted.

# Fields
$(TYPEDFIELDS)

"""
struct RegistryError <: Exception
    func::Function
    target_type::Any
end

function Base.showerror(io::IO, err::RegistryError)
    return println(
        io,
        "RegistryError:",
        " The type <$(err.target_type)> must implement <$(err.func)> to be registered.",
    )
end

"""
Abstract base type for exceptions indicating invalid input. See [`InvalidInputError`](@ref) for a simple concrete implementation. 
Concrete implementations should at least implement 

```Julia

Base.showerror(io::IO, err::CustomInvalidError) where {CustomInvalidError<:AbstractInvalidInputException}

```
"""
abstract type AbstractInvalidInputException <: Exception end

"""
    InvalidInputError(msg::String)

Exception which is thrown if a given input is invalid, e.g. passed to [`_assert_valid_input`](@ref).
"""
struct InvalidInputError <: AbstractInvalidInputException
    msg::String
end
function Base.showerror(io::IO, err::InvalidInputError)
    return println(io, "InvalidInputError: $(err.msg)")
end

mutable struct SpinorConstructionError <: Exception
    var::String
end

function Base.showerror(io::IO, e::SpinorConstructionError)
    return print(io, "SpinorConstructionError: ", e.var)
end

###############
# The process setup 
#
# In this file, we define the interface for general computation and process setups.
###############

"""
Abstract base type for computation setups.  A *setup* means
a collection of setup data needed to evaluate a dedicated quantity of given
running data. Therefore, each setup is associated with a single quantity, which one may compute using the setup data and the running data. 
Despite that, the decomposition into setup and running data is
arbitrary, and this can be used for cases where a subset of the variables a
quantity depends on is kept constant. 

!!! note "Computation setup interface"
    
    The computation performed using a computation setup is separated into three steps:
        
        1. input validation
        2. actual computation
        3. post processing

    where every step has its own interface function (see [`compute`](@ref) for details). 
    
    ## Input validation

    Every subtype of `AbstractComputationSetup` should implement the interface function
    
    ```Julia
    _assert_valid_input(stp::AbstractComputationSetup, input)
    ```
    
    which should throw and an exception subtyped from [`AbstractInvalidInputException`](@ref) if the `input` is not valid for the computation of the associated quantity (see [`_assert_valid_input`](@ref) for more details). 
    The default implementation does nothing, i.e. every input is valid by default. Provide a custom implementation if a different behavior is required.

    ## Actual computation
    
    Every subtype of `AbstractComputationSetup` must at least implement the required interface function
    
    ```Julia
    _compute(stp::AbstractComputationSetup, input) 
    ```
    
    which computes the value of the associated quantity for a given `input` (see [`_compute`](@ref) for more details).


    ## Post processing 

    Every subtype of `AbstractComputationSetup` should implement the interface function
    
    ```Julia
    _post_processing(stp::AbstractComputationSetup, input, result) 
    ```
    
    which performs task after the actual computation, e.g. conversions or normalizations (see [`_post_processing`](@ref) for more details).

"""
abstract type AbstractComputationSetup end

# convenience function to check if an object is a computation setup
_is_computation_setup(::AbstractComputationSetup) = true

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

"""
    _assert_valid_input(stp::AbstractComputationSetup, input::Any)

Interface function, which asserts that the given `input` is valid, and throws an [`InvalidInputError`](@ref) if not.

!!! note "default implementation"

    By default, every input is assumed to be valid. Therefore, this function does nothing. 
    To customize this behavior, add your own implementation of

    ```Julia
    _assert_valid_input(stp::YourCustomSetup,input)
    ```
    which should throw an exception, which is a subtype of [`AbstractInvalidInputException`](@ref). One may also use the concrete implementation [`InvalidInputError`](@ref) if the input is invalid instead of writing a custom exception type.

"""
@inline function _assert_valid_input(stp::AbstractComputationSetup, input)
    return nothing
end

"""
    function _post_processing(stp::AbstractComputationSetup, input::Any, result::Any)
    
Interface function, which is called in [`compute`](@ref) after [`_compute`](@ref) has been called. This function is dedicated to 
finalize the result of a computation. 

!!! note "default implementation"

    Since in the case of no post processing the result of [`_compute`](@ref) is unchanged, this function returns `result` by default.

"""
@inline function _post_processing(stp::AbstractComputationSetup, input, result)
    return result
end

"""
    _compute(stp::AbstractComputationSetup, input::Any)

Interface function that returns the value of the associated quantity evaluated on `input`, which can be anything the associated quantity is defined to be feasible for.

!!! note "unsafe implementation"

    This function must be implemented for any subtype of [`AbstractComputationSetup`](@ref). It should not do any input validation or post processing (see [`_assert_valid_input`](@ref) and [`_post_processing`](@ref)), as those two are performed while calling 
    the safe version of this function [`compute`](@ref).

"""
function _compute end

"""
    compute(stp::AbstractComputationSetup, input::Any)

Return the value of the quantity associated with `stp` for a given `input`. 
In addition to the actual call of the associated unsafe version [`_compute`](@ref),
input validation ([`_assert_valid_input`]) and post processing 
(using [`_post_processing`](@ref)) are wrapped around the calculation (see [`AbstractComputationSetup`](@ref) for details).
"""
function compute(stp::AbstractComputationSetup, input)
    _assert_valid_input(stp, input)
    raw_result = _compute(stp, input)
    return _post_processing(stp, input, raw_result)
end

"""
Abstract base type for setups related to combining scattering processes and physical models.  
Every subtype of `AbstractProcessSetup` must implement at least the following 
interface functions:

```Julia
scattering_process(::AbstractProcessSetup) 
physical_model(::AbstractProcessSetup) 
```

Derived from these interface functions, the following delegations are provided:

```Julia
number_incoming_particles(::AbstractProcessSetup)
number_outgoing_particles(::AbstractProcessSetup)
```

"""
abstract type AbstractProcessSetup <: AbstractComputationSetup end

"""
    scattering_process(stp::AbstractProcessSetup)

Interface function that returns the scattering process associated with `stp`,
i.e. an object which is a subtype of [`AbstractProcessDefinition`](@ref). 
"""
function scattering_process end

"""
    physical_model(stp::AbstractProcessSetup)

Interface function that returns the physical model associated with `stp`, i.e.
an object which is a subtype of [`AbstractModelDefinition`](@ref).
"""
function physical_model end

@inline number_incoming_particles(stp::AbstractProcessSetup) =
    number_incoming_particles(scattering_process(stp))
@inline number_outgoing_particles(stp::AbstractProcessSetup) =
    number_outgoing_particles(scattering_process(stp))

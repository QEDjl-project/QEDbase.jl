"""
$(SIGNATURES)

Wrapper around `Base.hasmethod` with a more meaningful error message in the context of function registration.
"""
function _hasmethod_registry(fun::Function, ::Type{T}) where {T}
    @argcheck hasmethod(fun, Tuple{T}) RegistryError(fun, T)
end

@traitdef IsLorentzVectorLike{T}
@traitdef IsMutableLorentzVectorLike{T}

"""
$(SIGNATURES)

Function to register a custom type as a LorentzVectorLike. 

Ensure the passed custom type has implemented at least the function `getT, getX, getY, getZ` 
and enables getter functions of the lorentz vector library for the given type. 
If additionally the functions `setT!, setX!, setY!, setZ!` are implemened for the passed custom type,
also the setter functions of the Lorentz vector interface are enabled.
"""
function register_LorentzVectorLike(T::Type)
    _hasmethod_registry(getT, T)
    _hasmethod_registry(getX, T)
    _hasmethod_registry(getY, T)
    _hasmethod_registry(getZ, T)

    @eval @traitimpl IsLorentzVectorLike{$T}

    if hasmethod(setT!, Tuple{T,<:Union{}}) &&
        hasmethod(setX!, Tuple{T,<:Union{}}) &&
        hasmethod(setY!, Tuple{T,<:Union{}}) &&
        hasmethod(setZ!, Tuple{T,<:Union{}})
        @eval @traitimpl IsMutableLorentzVectorLike{$T}
    end
    return nothing
end

# # Tutorial: Custom Four Momentum Vector
#
# This tutorial explains how to define a custom [`AbstractFourMomentum`](@ref) type that
# can be used to represent, for example, particle momenta in an [`AbstractParticleStateful`](@ref).
#
# ## Defining a Custom Four Momentum Type
#
# The `FourMomentum` interface in `QEDbase.jl` is designed to be extendable. By implementing
# a simple API, you can make any custom type behave like a Lorentz vector and unlock access
# to various kinematic functions in the package.

# ### Step 1: Define Your Custom Type
#
# To define a valid `AbstractFourMomentum` type, create a type with the fields `.E`, `.px`, `.py` and `.pz`.
using QEDbase

struct CustomFourMomentum <: AbstractFourMomentum
    E::Float64  # energy component
    px::Float64 # x component
    py::Float64 # y component
    pz::Float64 # z component
end

# ### Step 2: Add the necessary accessor functions

QEDbase.getT(p::CustomFourMomentum) = p.E
QEDbase.getX(p::CustomFourMomentum) = p.px
QEDbase.getY(p::CustomFourMomentum) = p.py
QEDbase.getZ(p::CustomFourMomentum) = p.pz

# ### Step 3: Register the type as a LorentzVectorLike

register_LorentzVectorLike(CustomFourMomentum)

# A mutable version can also be implemented by also defining the interface functions `setT!`, `setX!`, `setY!`, and `setZ!`.

# Example Usage:

mom = CustomFourMomentum(1.0, 0.0, 0.0, 1.0)
println("Defined momentum $mom is on shell: $(isonshell(mom))")

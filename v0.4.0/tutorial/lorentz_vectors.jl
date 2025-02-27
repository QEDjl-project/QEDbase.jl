# # Tutorial: Custom Lorentz Vectors
#
# [Lorentz vectors](https://en.wikipedia.org/wiki/Four-vector), which represent elements of
# Minkowski space, are fundamental mathematical objects in high-energy physics for describing
# the kinematic properties of particles. In particular, they are used to express four-momentum and other
# kinematic quantities.
#
# `QEDbase.jl` provides a flexible interface for working with Lorentz vectors and four-momenta,
# allowing seamless integration with custom types that represent Lorentz vectors. This enables
# users to extend the core functionality of the package to their own data structures, while
# taking advantage of optimized kinematic computations.
#
# ## Defining a Custom Lorentz Vector Type
#
# The `LorentzVector` interface in `QEDbase.jl` is designed to be extendable. By implementing
# a simple API, you can make any custom type behave like a Lorentz vector and unlock access
# to various kinematic functions in the package.

# ### Step 1: Define Your Custom Type
#
# Suppose you want to define a custom type that behaves like a Lorentz vector. Start by
# creating the type to hold the Cartesian components of the vector:
using QEDbase

struct CustomLorentzVector
    t::Float64   # time-like component
    x::Float64   # x-component of spatial vector
    y::Float64   # y-component of spatial vector
    z::Float64   # z-component of spatial vector
end

# ### Step 2: Implement the Lorentz Vector API
#
# To connect your custom type to the `LorentzVector` interface, you'll need to implement the
# required getters for the time and spatial components. These functions extract the respective
# components (`t`, `x`, `y`, and `z`) from your type:

QEDbase.getT(lv::CustomLorentzVector) = lv.t
QEDbase.getX(lv::CustomLorentzVector) = lv.x
QEDbase.getY(lv::CustomLorentzVector) = lv.y
QEDbase.getZ(lv::CustomLorentzVector) = lv.z

# ### Step 3: Register Your Custom Type as a `LorentzVectorLike`
#
# Once you've implemented the required API, you can register your custom type as a `LorentzVectorLike` by calling the following function:

register_LorentzVectorLike(CustomLorentzVector)

# If any required functions are missing or incorrectly implemented, this will raise a `RegistryError` that provides details on what needs to be fixed.

# ### Step 4: Using the Custom Lorentz Vector
#
# With your custom type registered, you can now use it as a Lorentz vector in various kinematic calculations.
# For example, the `CustomLorentzVector` can be used to calculate angles or rapidity:

L = CustomLorentzVector(2.0, 1.0, 0.0, -1.0)

println("Polar angle (theta)): ", getTheta(L))
println("Rapidity: ", getRapidity(L))

# ### Optional: Mutable Types
#
# If you need to modify the components of the Lorentz vector after its creation, you can
# implement setter functions for your custom type. This will allow your type to be mutable
# and provide access to additional mutating functions within the `QEDbase.jl` ecosystem.
#
# First: define another custom Lorentz vector type, but make it a mutable struct

mutable struct CustomMutableLorentzVector
    t::Float64   # time-like component
    x::Float64   # x-component of spatial vector
    y::Float64   # y-component of spatial vector
    z::Float64   # z-component of spatial vector
end

# Second: define the accessor functions for your mutable Lorentz vector

QEDbase.getT(lv::CustomMutableLorentzVector) = lv.t
QEDbase.getX(lv::CustomMutableLorentzVector) = lv.x
QEDbase.getY(lv::CustomMutableLorentzVector) = lv.y
QEDbase.getZ(lv::CustomMutableLorentzVector) = lv.z

#
# Third: enable mutability, implement the following setter methods
QEDbase.setT!(lv::CustomMutableLorentzVector, new_t) = (lv.t = new_t)
QEDbase.setX!(lv::CustomMutableLorentzVector, new_x) = (lv.x = new_x)
QEDbase.setY!(lv::CustomMutableLorentzVector, new_y) = (lv.y = new_y)
QEDbase.setZ!(lv::CustomMutableLorentzVector, new_z) = (lv.z = new_z)

# finally register your mutable Lorentz vector

register_LorentzVectorLike(CustomMutableLorentzVector)

# Once these setter methods are defined, your type will support mutable operations. You can
# then register your type and take advantage of mutating functions provided by `QEDbase.jl`.

# #### Example: Updating Rapidity
#
# After defining your custom type as mutable, you can use functions like `setRapidity!` to
# update the rapidity and other kinematic properties of the vector in place:

L = CustomMutableLorentzVector(2.0, 1.0, 0.0, -1.0)

println("rapidity before: ", getRapidity(L))
setRapidity!(L, 0.5)  # Updates the components accordingly
println("rapidity after: ", getRapidity(L))

# ## Summary
#
# In this tutorial, we learned how to:
#
# 1. Define a custom type to represent a Lorentz vector.
# 2. Implement the required API functions to integrate the type into the `LorentzVector` interface of `QEDbase.jl`.
# 3. Register the type as `LorentzVectorLike` to enable its use in kinematic calculations.
# 4. Optionally, we explored how to make the custom type mutable and enable modification of its components.

# By following these steps, you can extend `QEDbase.jl` to work with your own Lorentz vector types while benefiting from the library's optimized calculations.

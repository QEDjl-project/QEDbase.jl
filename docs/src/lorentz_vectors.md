# Lorentz Vectors in QEDbase.jl

[Lorentz vectors](https://en.wikipedia.org/wiki/Four-vector), which represent elements of
Minkowski space, are fundamental mathematical object in high-energy physics for describing the kinematic
properties of particles. In particular, they are used to expressing four-momentum and other
kinematic quantities.

`QEDbase.jl` provides a flexible interface for working with Lorentz vectors and four-momenta,
allowing seamless integration with custom types that represent Lorentz vectors. This enables
users to extend the core functionality of the package to their own data structures, while
taking advantage of optimized kinematic computations.

## Defining a Custom Lorentz Vector Type

The `LorentzVector` interface in `QEDbase.jl` is designed to be extendable. By implementing
a simple API, you can make any custom type behave like a Lorentz vector and unlock access
to various kinematic functions in the package.

### Step 1: Define Your Custom Type

Suppose you want to define a custom type that behaves like a Lorentz vector. Start by
creating the type to hold the Cartesian components of the vector:

```julia
struct CustomType
    t::Float64   # time-like component
    x::Float64   # x-component of spatial vector
    y::Float64   # y-component of spatial vector
    z::Float64   # z-component of spatial vector
end
```

> **Note**: there is no subtyping necessary, so you can implement the `LorentzVector` interface
> for any type in **your** type hierarchy. However, be aware to own the type to avoid of [type piracy](https://docs.julialang.org/en/v1/manual/style-guide/#Avoid-type-piracy).

### Step 2: Implement the Lorentz Vector API

To connect your custom type to the `LorentzVector` interface, you'll need to implement the
required getters for the time and spatial components. These functions extract the respective
components (`t`, `x`, `y`, and `z`) from your type:

```julia
QEDbase.getT(lv::CustomType) = lv.t
QEDbase.getX(lv::CustomType) = lv.x
QEDbase.getY(lv::CustomType) = lv.y
QEDbase.getZ(lv::CustomType) = lv.z
```

> **Note:** Ensure you dispatch on the `QEDbase` functions (`QEDbase.getT`, `QEDbase.getX`, etc.) to correctly integrate with the library.

### Step 3: Register Your Custom Type as a `LorentzVectorLike`

Once you've implemented the required API, you can register your custom type as a `LorentzVectorLike` by calling the following function:

```julia
register_LorentzVectorLike(CustomType)
```

If any required functions are missing or incorrectly implemented, this will raise a `RegistryError` that provides details on what needs to be fixed.

> **Note:** Technically, the registration will add your `CustomType` to the trait `LorentzVectorLike`, which implements the list of accessor functions
> for your type.

### Step 4: Using the Custom Lorentz Vector

With your custom type registered, you can now use it as a Lorentz vector in various kinematic calculations.
For example, the `CustomType` can be used to calculate angles or rapidity:

```julia
L = CustomType(2.0, 1.0, 0.0, -1.0)

getTheta(L)    # Calculate the polar angle (theta)
getRapidity(L) # Calculate the rapidity
```

### Optional: Mutable Types

If you need to modify the components of the Lorentz vector after its creation, you can
implement setter functions for your custom type. This will allow your type to be mutable
and provide access to additional mutating functions within the `QEDbase.jl` ecosystem.

To enable mutability, implement the following setter methods:

```julia
QEDbase.setT(lv::CustomType, new_t) = (lv.t = new_t)
QEDbase.setX(lv::CustomType, new_x) = (lv.x = new_x)
QEDbase.setY(lv::CustomType, new_y) = (lv.y = new_y)
QEDbase.setZ(lv::CustomType, new_z) = (lv.z = new_z)
```

Once these setter methods are defined, your type will support mutable operations. You can
then register your type and take advantage of mutating functions provided by `QEDbase.jl`.

#### Example: Updating Rapidity

After defining your custom type as mutable, you can use functions like `setRapidity!` to
update the rapidity and other kinematic properties of the vector in place:

```julia
L = CustomType(2.0, 1.0, 0.0, -1.0)

setRapidity!(L, 0.5)  # Updates the components accordingly
```

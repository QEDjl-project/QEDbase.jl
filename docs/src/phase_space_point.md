<-- TODO: check this for correctness -->

# Step-by-step implementation of a phase space point

## 0. Define an Example Process, Model, and Phase Space Definition

We will create some example definitions for the process (`PROC`), model (`MODEL`), and phase space definition (`PSDEF`), which will be used to define the `AbstractPhaseSpacePoint`.

```julia
# Define an example process (PROC)
abstract type AbstractProcessDefinition end
struct ExampleProcess <: AbstractProcessDefinition end

# Define an example model (MODEL)
abstract type AbstractModelDefinition end
struct ExampleModel <: AbstractModelDefinition end

# Define an example phase space definition (PSDEF)
abstract type AbstractPhasespaceDefinition end
struct ExamplePhaseSpace <: AbstractPhasespaceDefinition end
```

#### 1. **Implement `AbstractPhaseSpacePoint`:**

We now define a concrete `PhaseSpacePoint` that implements the `AbstractPhaseSpacePoint` interface. This structure represents the phase space point for a process with given incoming and outgoing particles.

```julia
abstract type AbstractPhaseSpacePoint{PROC, MODEL, PSDEF, IN_PARTICLES, OUT_PARTICLES} end

struct PhaseSpacePoint{PROC, MODEL, PSDEF, IN_PARTICLES, OUT_PARTICLES} <: AbstractPhaseSpacePoint{PROC, MODEL, PSDEF, IN_PARTICLES, OUT_PARTICLES}
    incoming_particles::IN_PARTICLES
    outgoing_particles::OUT_PARTICLES
    process_def::PROC
    model_def::MODEL
    psdef::PSDEF

    function PhaseSpacePoint{PROC, MODEL, PSDEF, IN_PARTICLES, OUT_PARTICLES}(incoming_particles::IN_PARTICLES, outgoing_particles::OUT_PARTICLES, process_def::PROC, model_def::MODEL, psdef::PSDEF)
        @assert !isempty(incoming_particles) || !isempty(outgoing_particles) "Both incoming and outgoing particles cannot be empty!"
        new{PROC, MODEL, PSDEF, IN_PARTICLES, OUT_PARTICLES}(incoming_particles, outgoing_particles, process_def, model_def, psdef)
    end
end
```

#### 3. **Implement Required Interface Functions:**

Now, we provide the required interface functions: `Base.getindex`, `particles`, `process`, `model`, and `phase_space_definition`.

```julia
# Retrieve nth particle (either incoming or outgoing) based on direction
function Base.getindex(psp::PhaseSpacePoint, dir::ParticleDirection, n::Int)
    if dir isa IncomingParticle
        return psp.incoming_particles[n]
    elseif dir isa OutgoingParticle
        return psp.outgoing_particles[n]
    else
        throw(BoundsError("Invalid particle direction or index"))
    end
end

# Return all particles based on direction
function particles(psp::PhaseSpacePoint, dir::ParticleDirection)
    if dir isa IncomingParticle
        return psp.incoming_particles
    elseif dir isa OutgoingParticle
        return psp.outgoing_particles
    else
        throw(ArgumentError("Invalid particle direction"))
    end
end

# Return the process
process(psp::PhaseSpacePoint) = psp.process_def

# Return the model
model(psp::PhaseSpacePoint) = psp.model_def

# Return the phase space definition
phase_space_definition(psp::PhaseSpacePoint) = psp.psdef
```

#### 4. **Automatically Derived Functions (Momentum Accessors):**

Functions like `momentum` and `momenta` are derived automatically, based on the existing particle access functions.

```julia
# Retrieve momentum for nth particle based on direction
function momentum(psp::PhaseSpacePoint, dir::ParticleDirection, n::Int)
    return getindex(psp, dir, n).momentum
end

# Retrieve all momenta for a given direction
function momenta(psp::PhaseSpacePoint, dir::ParticleDirection)
    return Tuple(p.momentum for p in particles(psp, dir))
end
```

#### 5. **Example Usage:**

Finally, let's define an example usage with incoming and outgoing particles.

```julia
# Example particles with momenta (px, py, pz, E)
incoming_particles = (ExampleParticleStateful((1.0, 0.0, 0.0, 1.0)), ExampleParticleStateful((0.0, 1.0, 0.0, 1.0)))
outgoing_particles = (ExampleParticleStateful((0.5, 0.5, 0.0, 1.0)), ExampleParticleStateful((0.5, -0.5, 0.0, 1.0)))

# Example process, model, and phase space definition
proc = ExampleProcess()
model = ExampleModel()
psdef = ExamplePhaseSpace()

# Create a phase space point
psp = PhaseSpacePoint(incoming_particles, outgoing_particles, proc, model, psdef)

# Access incoming momenta
println("Incoming momenta: ", momenta(psp, IncomingParticle()))

# Access outgoing momenta
println("Outgoing momenta: ", momenta(psp, OutgoingParticle()))

# Get the 1st incoming particle momentum
println("First incoming particle momentum: ", momentum(psp, IncomingParticle(), 1))
```

### Explanation:

- **PhaseSpacePoint Type:** We defined the `PhaseSpacePoint` struct as a subtype of `AbstractPhaseSpacePoint`, which holds the incoming and outgoing particles, process definition, model, and phase space definition.
- **Interface Functions:** Implemented required functions (`Base.getindex`, `particles`, `process`, `model`, `phase_space_definition`) to comply with the specified interface.
- **Derived Functions:** Used the `particles` function to derive momentum-related functions (`momentum`, `momenta`).
- **Error Handling:** Ensured that both incoming and outgoing particles are not empty, following the validation rules.

This implementation provides a flexible way to represent points in the phase space of a process, and the interface can easily accommodate different particle states and coordinate systems.

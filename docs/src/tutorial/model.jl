# # Tutorial: Custom Physics Model Definition

# In this tutorial, we define a custom physics model by implementing the [`AbstractModelDefinition`](@ref)
# interface from QEDbase.

# First we need particle definitions from the particles tutorial:

redirect_stdout(devnull) do # hide
include(joinpath(dirname(Base.active_project()), "src", "tutorial", "particle.jl"))    # to get predefined particles
end # hide

struct CustomModel <: AbstractModelDefinition end

# The fundamental interaction must be defined by a symbol:

QEDbase.fundamental_interaction_type(::CustomModel) = :electromagnetic

# Next, we define the incoming and outgoing phase space dimensions:

function QEDbase.in_phase_space_dimension(proc::AbstractProcessDefinition, ::CustomModel)
    return 3 * number_incoming_particles(proc) - 4 - 1
end

function QEDbase.out_phase_space_dimension(proc::AbstractProcessDefinition, ::CustomModel)
    return 3 * number_outgoing_particles(proc) - 4
end

# The [`isphysical`](@extref QEDprocesses.isphysical) function should return whether the given process is physical in this model.
# For the electromagnetic interaction this means the fermion and anti-fermions need to match up.

function isphysical(proc::AbstractProcessDefinition, ::CustomModel)
    return (
        number_particles(proc, Incoming(), Muon()) +
        number_particles(proc, Outgoing(), AntiMuon()) ==
        number_particles(proc, Incoming(), AntiMuon()) +
        number_particles(proc, Outgoing(), Muon())
    ) && number_particles(proc, Incoming()) + number_particles(proc, Outgoing()) >= 2
end

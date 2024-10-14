###############
# The model interface
#
# In this file, we define the interface of working with compute models in
# general.
###############
# root type for models
"""
Abstract base type for all compute model definitions in the context of scattering processes. Every subtype of `AbstractModelDefinition` is associated with a fundamental interaction.
Therefore, one needs to implement the following soft interface function

```Julia
fundamental_interaction_type(::AbstractModelDefinition)
```
"""
abstract type AbstractModelDefinition end

# broadcast every model as a scalar
Broadcast.broadcastable(model::AbstractModelDefinition) = Ref(model)

"""
    fundamental_interaction_type(models_def::AbstractModelDefinition)

Return the fundamental interaction associated with the passed model definition.
"""
function fundamental_interaction_type end

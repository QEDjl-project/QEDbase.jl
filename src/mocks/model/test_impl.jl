
"""
    struct MockModel <: AbstractModelDefinition

A mock model definition used for testing and validation purposes.

This model serves as a placeholder within the framework, returning a predefined
interaction type when queried.

# Methods
- `QEDbase.fundamental_interaction_type(::MockModel)`: Returns the fundamental
  interaction type by calling `_groundtruth_interaction_type()`.

# Example
```julia
model = MockModel()
interaction_type = QEDbase.fundamental_interaction_type(model)
# Output: :mock_interaction
```
"""
struct MockModel <: AbstractModelDefinition end

QEDbase.fundamental_interaction_type(::MockModel) = _groundtruth_interaction_type()

"""
    struct MockModel_FAIL <: AbstractModelDefinition

A mock model definition intended to represent an incorrect or failing model.

This type can be used in tests to verify error handling and robustness of the
framework when encountering invalid models.

# Usage
`MockModel_FAIL` does not define `fundamental_interaction_type` and can be used
to test behavior when a model lacks proper definitions.

# Example
```julia
model_fail = MockModel_FAIL()
# This may trigger an error if the framework expects a valid interaction type.
```
"""
struct MockModel_FAIL <: AbstractModelDefinition end

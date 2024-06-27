"""
This module provides a full implementation of the model and process interface. Its purpose is only for testing and it does not reflect any 
real-world physics. 

The module exports:

```
TestParticle1               # set of test particles without properties
TestParticle2
TestParticle3
TestParticle4
TestModel                   # dummy compute model
TestModel_FAIL              # failing compute model
TestProcess                 # dummy scattering process 
TestProcess_FAIL            # failing scattering process 
TestPhasespaceDef           # dummy phase space definition
TestPhasespaceDef_FAIL      # failing phase space definition
```
The respective groundtruth implementations for the interface functions are stored in `groundtruths.jl`
"""
module TestImplementation

export TestParticle1, TestParticle2, TestParticle3, TestParticle4, PARTICLE_SET
export TestModel, TestModel_FAIL
export TestProcess, TestProcess_FAIL
export TestPhasespaceDef, TestPhasespaceDef_FAIL

using Random
using QEDbase: QEDbase
using QEDcore
using QEDprocesses
using StaticArrays

include("groundtruths.jl")
include("test_model.jl")
include("test_process.jl")
include("random_momenta.jl")
include("utils.jl")

end

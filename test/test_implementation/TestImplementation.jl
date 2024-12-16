module TestImplementation

export TestMomentum, TestMomentumMutable
export TestFermion, TestBoson

export TestModel, TestModel_FAIL
export TestProcess, TestProcess_FAIL

# to be removed
export TestPhasespaceDef, TestPhasespaceDef_FAIL

export TestInPhaseSpaceLayout, TestInPhaseSpaceLayout_FAIL
export TestOutPhaseSpaceLayout, TestOutPhaseSpaceLayout_FAIL

export TestParticleStateful
export TestPhaseSpacePoint

export TestCoordinateTrafo

using Random
using QEDbase
using StaticArrays

include("momentum/test_impl.jl")
include("momentum/utils.jl")
include("momentum/rand.jl")

include("particles/groundtruth.jl")
include("particles/test_impl.jl")

include("model/groundtruth.jl")
include("model/test_impl.jl")

include("process/groundtruth.jl")
include("process/test_impl.jl")

# to be removed
include("phase_space_def/groundtruth.jl")
include("phase_space_def/test_impl.jl")
include("phase_space_def/utils.jl")

include("phase_space_layout/groundtruth.jl")
include("phase_space_layout/test_impl.jl")

include("particle_stateful.jl")
include("phase_space_point.jl")

include("cross_section/groundtruth.jl")
include("cross_section/test_impl.jl")

include("coordinate_trafo/groundtruth.jl")
include("coordinate_trafo/test_impl.jl")

include("utils.jl")

end

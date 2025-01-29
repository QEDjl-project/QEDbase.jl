module Mocks

export MockMomentum, MockMomentumMutable
export MockFermion, MockBoson
export MockMasslessFermion, MockMasslessBoson

export MockModel, MockModel_FAIL
export MockProcess, MockProcess_FAIL

# TODO: to be removed (https://github.com/QEDjl-project/QEDbase.jl/issues/140)
export MockPhasespaceDef, MockPhasespaceDef_FAIL

export MockInPhaseSpaceLayout, MockInPhaseSpaceLayout_FAIL
export MockOutPhaseSpaceLayout, MockOutPhaseSpaceLayout_FAIL

export MockParticleStateful
export MockPhaseSpacePoint, MockInPhaseSpacePoint

export MockCoordinateTrafo

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
include("phase_space_point/test_impl.jl")
include("phase_space_point/utils.jl")

include("cross_section/groundtruth.jl")
include("cross_section/test_impl.jl")

include("coordinate_trafo/groundtruth.jl")
include("coordinate_trafo/test_impl.jl")

include("utils.jl")

end

using QEDbase
using Test

@testset "QEDbase.jl" begin
    include("dirac_tensor.jl")
    include("lorentz_vector.jl")
    include("lorentz_interface.jl")

    include("gamma_matrices.jl")

    include("particle_spinors.jl")
    include("four_momentum.jl")
<<<<<<< HEAD

    include("particles.jl")
=======
>>>>>>> baec5cc (Enhancement for the gitlab-ci)
end

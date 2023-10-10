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
<<<<<<< HEAD

    include("particles.jl")
=======
>>>>>>> baec5cc (Enhancement for the gitlab-ci)
=======

    include("particles.jl")
>>>>>>> aa78a7d (Move particle definitions from QEDprocesses.jl to QEDbase.jl (#25))
end

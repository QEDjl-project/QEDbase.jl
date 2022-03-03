using QEDbase
using Test

@testset "QEDbase.jl" begin

    #include("dirac_tensor.jl")
    #include("lorentz_vector.jl")
    include("lorentz_interface.jl")

    #include("gamma_matrices.jl")

    #include("particle_spinors.jl")

end

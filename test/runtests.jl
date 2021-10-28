using QEDbase
using Test

@testset "QEDbase.jl" begin

    include("dirac_tensor.jl")
    include("lorentz_vector.jl")

    include("gamma_matrices.jl")

end

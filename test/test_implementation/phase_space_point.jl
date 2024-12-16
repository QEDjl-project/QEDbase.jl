
#TODO: implement TestInPSP and TestOutPSP as special cases of TestPhaseSpacePoint

struct TestPhaseSpacePoint{
    P<:AbstractProcessDefinition,
    M<:AbstractModelDefinition,
    D<:AbstractPhasespaceDefinition,
    INP<:Tuple{Vararg{TestParticleStateful}},
    OUTP<:Tuple{Vararg{TestParticleStateful}},
} <: AbstractPhaseSpacePoint{P,M,D,INP,OUTP}
    proc::P
    model::M
    ps_def::D
    in_parts::INP
    out_parts::OUTP
end

function TestPhaseSpacePoint(
    proc::P, model::M, ps_def::D, in_moms::INP, out_moms::OUTP
) where {
    P<:AbstractProcessDefinition,
    M<:AbstractModelDefinition,
    D<:AbstractPhasespaceDefinition,
    INP<:Tuple,
    OUTP<:Tuple,
}
    in_parts = incoming_particles(proc)
    out_parts = outgoing_particles(proc)

    in_part_sf = Tuple([
        TestParticleStateful(Incoming(), p, m) for (p, m) in zip(in_parts, in_moms)
    ])
    out_part_sf = Tuple([
        TestParticleStateful(Outgoing(), p, m) for (p, m) in zip(out_parts, out_moms)
    ])

    return TestPhaseSpacePoint(proc, model, ps_def, in_part_sf, out_part_sf)
end

Base.getindex(psp::TestPhaseSpacePoint, ::Incoming, n::Int) = psp.in_parts[n]
Base.getindex(psp::TestPhaseSpacePoint, ::Outgoing, n::Int) = psp.out_parts[n]

QEDbase.particles(psp::TestPhaseSpacePoint, ::Incoming) = psp.in_parts
QEDbase.particles(psp::TestPhaseSpacePoint, ::Outgoing) = psp.out_parts

QEDbase.process(psp::TestPhaseSpacePoint) = psp.proc
QEDbase.model(psp::TestPhaseSpacePoint) = psp.model
QEDbase.phase_space_definition(psp::TestPhaseSpacePoint) = psp.ps_def

function Base.isapprox(
    psp1::TestPhaseSpacePoint,
    psp2::TestPhaseSpacePoint;
    atol::Real=0.0,
    rtol::Real=Base.rtoldefault(Float64),
    nans::Bool=false,
    norm::Function=abs,
)
    return process(psp1) == process(psp2) &&
           model(psp1) == model(psp2) &&
           phase_space_definition(psp1) == phase_space_definition(psp2) &&
           all(
               isapprox.(
                   momenta(psp1, Incoming()),
                   momenta(psp2, Incoming());
                   atol=atol,
                   rtol=rtol,
                   nans=nans,
                   norm=norm,
               ),
           ) &&
           all(
               isapprox.(
                   momenta(psp1, Outgoing()),
                   momenta(psp2, Outgoing());
                   atol=atol,
                   rtol=rtol,
                   nans=nans,
                   norm=norm,
               ),
           )
end

#=

Main.TestImplementation.TestPhaseSpacePoint{
    Main.TestImplementation.TestProcess{
        Tuple{Main.TestImplementation.TestFermion},
        Tuple{Main.TestImplementation.TestFermion}
    },
    Main.TestImplementation.TestModel,
    Main.TestImplementation.TestPhasespaceDef{Main.TestImplementation.TestMomentum},
    Tuple{
        Main.TestImplementation.TestParticleStateful{
            QEDbase.Incoming,
            Main.TestImplementation.TestFermion,
            Main.TestImplementation.TestMomentum{Float64}
        }
    },
    Tuple{
        Main.TestImplementation.TestParticleStateful{
            QEDbase.Outgoing,
            Main.TestImplementation.TestFermion,
            Main.TestImplementation.TestMomentum{Float64}
        }
    }
}
does not match inferred return type

Main.TestImplementation.TestPhaseSpacePoint{
    Main.TestImplementation.TestProcess{
        Tuple{Main.TestImplementation.TestFermion},
        Tuple{Main.TestImplementation.TestFermion}
    },
    Main.TestImplementation.TestModel,
    Main.TestImplementation.TestPhasespaceDef{Main.TestImplementation.TestMomentum},
    INP,
    OUTP
} where {INP<:Tuple{Vararg{Main.TestImplementation.TestParticleStateful{QEDbase.Incoming, Main.TestImplem
entation.TestFermion, Main.TestImplementation.TestMomentum{Float64}}}}, OUTP<:Tuple{Vararg{Main.TestImplementation.TestParticleStateful{QEDbase.Outgoing, Main.TestImplementation.TestFermion, Main.TestImplementation.TestMomentum{Float64}}}}}

=#


struct TestPhaseSpacePoint{
    P<:AbstractProcessDefinition,
    M<:AbstractModelDefinition,
    L<:AbstractPhaseSpaceLayout,
    INP<:Tuple{Vararg{TestParticleStateful}},
    OUTP<:Tuple{Vararg{TestParticleStateful}},
} <: AbstractPhaseSpacePoint{P,M,L,INP,OUTP}
    proc::P
    model::M
    psl::L
    in_parts::INP
    out_parts::OUTP
end

function TestPhaseSpacePoint(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    psl::AbstractPhaseSpaceLayout,
    in_moms::NTuple{N,MOM_TYPE},
    out_moms::NTuple{M,MOM_TYPE},
) where {N,M,MOM_TYPE<:AbstractFourMomentum}
    in_parts = _build_particle_statefuls(proc, in_moms, Incoming())
    out_parts = _build_particle_statefuls(proc, out_moms, Outgoing())

    return TestPhaseSpacePoint(proc, model, psl, in_parts, out_parts)
end

TestInPhaseSpacePoint{P,M,L,IN,OUT} = TestPhaseSpacePoint{
    P,M,L,IN,OUT
} where {IN<:Tuple{TestParticleStateful,Vararg},OUT<:Tuple{Vararg}}

function TestInPhaseSpacePoint(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    psl::AbstractPhaseSpaceLayout,
    in_momenta::NTuple{N,MOM_TYPE},
) where {N,MOM_TYPE<:AbstractFourMomentum}
    in_particles = _build_particle_statefuls(proc, in_momenta, Incoming())

    return TestPhaseSpacePoint(proc, model, psl, in_particles, ())
end

Base.getindex(psp::TestPhaseSpacePoint, ::Incoming, n::Int) = psp.in_parts[n]
Base.getindex(psp::TestPhaseSpacePoint, ::Outgoing, n::Int) = psp.out_parts[n]

QEDbase.particles(psp::TestPhaseSpacePoint, ::Incoming) = psp.in_parts
QEDbase.particles(psp::TestPhaseSpacePoint, ::Outgoing) = psp.out_parts

QEDbase.process(psp::TestPhaseSpacePoint) = psp.proc
QEDbase.model(psp::TestPhaseSpacePoint) = psp.model
QEDbase.phase_space_layout(psp::TestPhaseSpacePoint) = psp.psl

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
           phase_space_layout(psp1) == phase_space_layout(psp2) &&
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

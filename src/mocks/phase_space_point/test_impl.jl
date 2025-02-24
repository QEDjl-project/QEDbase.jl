
struct MockPhaseSpacePoint{
    P<:AbstractProcessDefinition,
    M<:AbstractModelDefinition,
    L<:AbstractPhaseSpaceLayout,
    INP<:Tuple{Vararg{MockParticleStateful}},
    OUTP<:Tuple{Vararg{MockParticleStateful}},
} <: AbstractPhaseSpacePoint{P,M,L,INP,OUTP}
    proc::P
    model::M
    psl::L
    in_parts::INP
    out_parts::OUTP
end

function MockPhaseSpacePoint(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    psl::AbstractPhaseSpaceLayout,
    in_moms::NTuple{N,MOM_TYPE},
    out_moms::NTuple{M,MOM_TYPE},
) where {N,M,MOM_TYPE<:AbstractFourMomentum}
    in_parts = _build_particle_statefuls(proc, in_moms, Incoming())
    out_parts = _build_particle_statefuls(proc, out_moms, Outgoing())

    return MockPhaseSpacePoint(proc, model, psl, in_parts, out_parts)
end

MockInPhaseSpacePoint{P,M,L,IN,OUT} = MockPhaseSpacePoint{
    P,M,L,IN,OUT
} where {IN<:Tuple{MockParticleStateful,Vararg},OUT<:Tuple{Vararg}}

function MockInPhaseSpacePoint(
    proc::AbstractProcessDefinition,
    model::AbstractModelDefinition,
    psl::AbstractPhaseSpaceLayout,
    in_momenta::NTuple{N,MOM_TYPE},
) where {N,MOM_TYPE<:AbstractFourMomentum}
    in_particles = _build_particle_statefuls(proc, in_momenta, Incoming())

    return MockPhaseSpacePoint(proc, model, psl, in_particles, ())
end

Base.getindex(psp::MockPhaseSpacePoint, ::Incoming, n::Int) = psp.in_parts[n]
Base.getindex(psp::MockPhaseSpacePoint, ::Outgoing, n::Int) = psp.out_parts[n]

QEDbase.particles(psp::MockPhaseSpacePoint, ::Incoming) = psp.in_parts
QEDbase.particles(psp::MockPhaseSpacePoint, ::Outgoing) = psp.out_parts

QEDbase.process(psp::MockPhaseSpacePoint) = psp.proc
QEDbase.model(psp::MockPhaseSpacePoint) = psp.model
QEDbase.phase_space_layout(psp::MockPhaseSpacePoint) = psp.psl

function Base.isapprox(
    psp1::MockPhaseSpacePoint,
    psp2::MockPhaseSpacePoint;
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

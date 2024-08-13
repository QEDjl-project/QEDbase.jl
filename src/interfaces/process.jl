###############
# The process interface
#
# In this file, we define the interface for working with scattering processes in
# general.
###############

"""
Abstract base type for definitions of scattering processes. It is the root type for the 
process interface, which assumes that every subtype of `AbstractProcessDefinition`
implements at least 

```Julia
incoming_particles(proc_def::AbstractProcessDefinition)
outgoing_particles(proc_def::AbstractProcessDefinition)
```

which return a tuple of the incoming and outgoing particles, respectively.

An `AbstractProcessDefinition` is also expected to contain spin and polarization information of its particles.
For this, the functions

```Julia
incoming_spin_pols(proc_def::AbstractProcessDefinition)
outgoing_spin_pols(proc_def::AbstractProcessDefinition)
```

can be overloaded. They must return a tuple of [`AbstractSpinOrPolarization`], where the order must match the order of the process' particles.
A default implementation is provided which assumes [`AllSpin`](@ref) for every [`is_fermion`](@ref) particle and [`AllPolarization`](@ref) for every [`is_boson`](@ref) particle.

On top of these spin and polarization functions, the following functions are automatically defined:

```Julia
multiplicity(proc_def::AbstractProcessDefinition)
incoming_multiplicity(proc_def::AbstractProcessDefinition)
outgoing_multiplicity(proc_def::AbstractProcessDefinition)
```

Which return the number of spin and polarization combinations that should be considered for the process. For more detail, refer to the functions' documentations.

Furthermore, to calculate scattering probabilities and differential cross sections, the following 
interface functions need to be implemented for every combination of `CustomProcess<:AbstractProcessDefinition`, 
`CustomModel<:AbstractModelDefinition`, and `CustomPhasespaceDefinition<:AbstractPhasespaceDefinition`.

```Julia
    _incident_flux(psp::InPhaseSpacePoint{CustomProcess,CustomModel})

    _matrix_element(psp::PhaseSpacePoint{CustomProcess,CustomModel})

    _averaging_norm(proc::CustomProcess)

    _is_in_phasespace(psp::PhaseSpacePoint{CustomProcess,CustomModel})

    _phase_space_factor(psp::PhaseSpacePoint{CustomProcess,CustomModel,CustomPhasespaceDefinition})
```

Optional is the implementation of 

```Julia

    _total_probability(psp::PhaseSpacePoint{CustomProcess,CustomModel,CustomPhasespaceDefinition})

```
to enable the calculation of total probabilities and cross sections.
"""
abstract type AbstractProcessDefinition end

# broadcast every process as a scalar
Broadcast.broadcastable(proc::AbstractProcessDefinition) = Ref(proc)

"""
    incoming_particles(proc_def::AbstractProcessDefinition)

Interface function for scattering processes. Return a tuple of the incoming particles for the given process definition.
This function needs to be given to implement the scattering process interface.

See also: [`AbstractParticleType`](@ref)
"""
function incoming_particles end

"""
    outgoing_particles(proc_def::AbstractProcessDefinition)

Interface function for scattering processes. Return the tuple of outgoing particles for the given process definition.
This function needs to be given to implement the scattering process interface.

See also: [`AbstractParticleType`](@ref)
"""
function outgoing_particles end

"""
    incoming_spin_pols(proc_def::AbstractProcessDefinition)

Interface function for scattering processes. Return the tuple of spins or polarizations for the given process definition. The order must be the same as the particles returned from [`incoming_particles`](@ref).
A default implementation is provided, returning [`AllSpin`](@ref) for every [`is_fermion`](@ref) and [`AllPolarization`](@ref) for every [`is_boson`](@ref).

See also: [`AbstractSpinOrPolarization`](@ref)
"""
function incoming_spin_pols end

"""
    outgoing_spin_pols(proc_def::AbstractProcessDefinition)

Interface function for scattering processes. Return the tuple of spins or polarizations for the given process definition. The order must be the same as the particles returned from [`outgoing_particles`](@ref).
A default implementation is provided, returning [`AllSpin`](@ref) for every [`is_fermion`](@ref) and [`AllPolarization`](@ref) for every [`is_boson`](@ref).

See also: [`AbstractSpinOrPolarization`](@ref)
"""
function outgoing_spin_pols end

"""
    _incident_flux(in_psp::InPhaseSpacePoint{PROC,MODEL}) where {
        PROC <: AbstractProcessDefinition,
        MODEL <: AbstractModelDefinition,
    }

Interface function which returns the incident flux of the given scattering process for a given `InPhaseSpacePoint`.
"""
function _incident_flux end

"""
    _matrix_element(PhaseSpacePoint{PROC,MODEL}) where {
        PROC <: AbstractProcessDefinition,
        MODEL <: AbstractModelDefinition,
    }

Interface function which returns a tuple of scattering matrix elements for each spin and polarization combination of `proc`. 
"""
function _matrix_element end

"""
    _averaging_norm(proc::AbstractProcessDefinition)

Interface function, which returns a normalization for the averaging of the squared matrix elements over spins and polarizations. 
"""
function _averaging_norm end

"""
    _is_in_phasespace(PhaseSpacePoint{PROC,MODEL}) where {
        PROC <: AbstractProcessDefinition,
        MODEL <: AbstractModelDefinition,
    }

Interface function which returns `true` if the combination of the given incoming and outgoing phase space
is physical, i.e. all momenta are on-shell and some sort of energy-momentum conservation holds.
"""
function _is_in_phasespace end

"""
    _phase_space_factor(PhaseSpacePoint{PROC,MODEL,PSDEF}) where {
        PROC <: AbstractProcessDefinition,
        MODEL <: AbstractModelDefinition
        PSDEF <: AbstractPhasespaceDefinition,
    }

Interface function, which returns the pre-differential factor of the invariant phase space intergral measure. 

!!! note "Convention"

    It is assumed, that this function returns the value of 

    ```math
    \\mathrm{d}\\Pi_n:= \\prod_{i=1}^N \\frac{\\mathrm{d}^3p_i}{(2\\pi)^3 2 p_i^0} H(P_t, p_1, \\dots, p_N),
    ```
where ``H(\\dots)`` is a characteristic function (or distribution) which constrains the phase space, e.g. ``\\delta^{(4)}(P_t - \\sum_i p_i)``.  
"""
function _phase_space_factor end

"""
    in_phase_space_dimension(
        proc::AbstractProcessDefinition,
        model::AbstractModelDefinition,
    )
TBW
"""
function in_phase_space_dimension end

"""
    out_phase_space_dimension(
        proc::AbstractProcessDefinition,
        model::AbstractModelDefinition,
    )
TBW
"""
function out_phase_space_dimension end

"""
    _total_probability(in_psp::InPhaseSpacePoint{PROC,MODEL}) where {
        PROC <: AbstractProcessDefinition,
        MODEL <: AbstractModelDefinition,
    }

Interface function for the combination of a scattering process and a physical model. Return the total of a 
given process and model for a passed `InPhaseSpacePoint`.

!!! note "total cross section"
    
    Given an implementation of this method and [`_incident_flux`](@ref), the respective function for the total cross section [`total_cross_section`](@ref) is also available.

"""
function _total_probability end

#####
# Generation of four-momenta from coordinates
#
# This file contains the interface and functionality to compute momenta from
# given coordinates.
#####

"""
    _generate_incoming_momenta(
        proc::AbstractProcessDefinition,
        model::AbstractModelDefinition,
        phase_space_def::AbstractPhasespaceDefinition,
        in_phase_space::NTuple{N,T},
    ) where {N,T<:Real}

Interface function to generate the four-momenta of the incoming particles from coordinates for a given phase-space definition.
"""
function _generate_incoming_momenta end

"""
    _generate_outgoing_momenta(
        proc::AbstractProcessDefinition,
        model::AbstractModelDefinition,
        phase_space_def::AbstractPhasespaceDefinition,
        in_phase_space::NTuple{N,T},
        out_phase_space::NTuple{M,T},
    ) where {N,M,T<:Real}

Interface function to generate the four-momenta of the outgoing particles from coordinates for a given phase-space definition.
"""
function _generate_outgoing_momenta end

"""
    _groundtruth_incident_flux(in_ps)

Test implementation of the incident flux. Return the Minkowski square of the sum of the incoming momenta:

```math
\\begin{align}
I = \\left(\\sum p_i\\right)^2,
\\end{align}
```
where \$p_i\\in\\mathrm{ps_in}\$.
"""
function _groundtruth_incident_flux(in_ps)
    s = sum(in_ps)
    return s * s
end

"""
    _groundtruth_matrix_element(in_ps, out_ps)

Test implementation for a matrix elements. Returns a list of three complex numbers without any physical meaning.
"""
function _groundtruth_matrix_element(in_ps, out_ps)
    s_in = sum(in_ps)
    s_out = sum(out_ps)
    res = s_in * s_in + 1im * (s_out * s_out)
    return (res, 2 * res, 3 * res)
end

"""
    _groundtruth_averaging_norm(proc)

Test implementation of the averaging norm. Returns the inverse of the sum of all external particles of the passed process.
"""
function _groundtruth_averaging_norm(proc)
    return 1.0 / (number_incoming_particles(proc) + number_outgoing_particles(proc))
end

"""
    _groundtruth_is_in_phasespace(in_ps, out_ps)

Test implementation of the phase space check. Return `false` if either the momentum of the first incoming particle is exactly `zero(SFourMomentum)`, or if the momentum of the last outgoing momentum is exactly `ones(SFourMomentum)`. Otherwise, return true.
"""
function _groundtruth_is_in_phasespace(in_ps, out_ps)
    # TODO: drop support for SFourMomentum
    if in_ps[1] == SFourMomentum(zeros(4))
        return false
    end
    if out_ps[end] == ones(SFourMomentum)
        return false
    end
    return true
end

"""
    _groundtruth_phase_space_factor(in_ps, out_ps)

Test implementation of the phase space factor. Return the inverse of the product of the energies of all external particles.
"""
function _groundtruth_phase_space_factor(in_ps, out_ps)
    en_in = QEDbase.getE.(in_ps)
    en_out = QEDbase.getE.(out_ps)
    return 1 / (prod(en_in) * prod(en_out))
end

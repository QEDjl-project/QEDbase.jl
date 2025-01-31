function _groundtruth_in_ps_dim(proc)
    return number_incoming_particles(proc) * 4
end

function _groundtruth_out_ps_dim(proc)
    return number_outgoing_particles(proc) * 4
end

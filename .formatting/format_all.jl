using JuliaFormatter

not_formatted = format(pwd(); verbose=true)
if not_formatted
    @info "Formatting verified."
else
    @warn "Formatting verification failed: Some files are not properly formatted!"
end
exit(not_formatted ? 0 : 1)

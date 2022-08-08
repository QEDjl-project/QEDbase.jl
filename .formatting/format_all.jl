using JuliaFormatter

<<<<<<< HEAD
# we asume the format_all.jl script is located in QEDbase.jl/.formatting
project_path = Base.Filesystem.joinpath(Base.Filesystem.dirname(Base.source_path()), "..")

not_formatted = format(project_path; verbose=true)
=======
not_formatted = format(pwd(); verbose=true)
>>>>>>> baec5cc (Enhancement for the gitlab-ci)
if not_formatted
    @info "Formatting verified."
else
    @warn "Formatting verification failed: Some files are not properly formatted!"
end
exit(not_formatted ? 0 : 1)

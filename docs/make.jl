
using Pkg

# targeting the correct source code
# this asumes the make.jl script is located in QEDbase.jl/docs
project_path = Base.Filesystem.joinpath(Base.Filesystem.dirname(Base.source_path()), "..")
Pkg.develop(; path=project_path)

using Documenter
using Literate
using DocumenterInterLinks
using DocumenterCitations

using QEDbase

# some paths for links
readme_path = joinpath(project_path, "README.md")
index_path = joinpath(project_path, "docs/src/index.md")
license_path = "https://github.com/QEDjl-project/QEDbase.jl/blob/main/LICENSE"

# Copy README.md from the project base folder and use it as the start page
open(readme_path, "r") do readme_in
    readme_string = read(readme_in, String)

    # replace relative links in the README.md
    readme_string = replace(readme_string, "[MIT](LICENSE)" => "[MIT]($(license_path))")

    open(index_path, "w") do readme_out
        write(readme_out, readme_string)
    end
end

# setup interlinks
links = InterLinks(
    "QEDcore" => "https://qedjl-project.github.io/QEDcore.jl/dev/",
    "QEDprocesses" => "https://qedjl-project.github.io/QEDprocesses.jl/dev/",
)

# setup Bibliography
bib = CitationBibliography(joinpath(dirname(Base.active_project()), "Bibliography.bib"))

# setup examples using Literate.jl
literate_paths = [
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/four_momentum.jl"),
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/lorentz_vectors.jl"),
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/model.jl"),
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/particle.jl"),
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/particle_stateful.jl"),
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/process.jl"),
    Base.Filesystem.joinpath(project_path, "docs/src/tutorial/phase_space_point.jl"),
]

tutorial_output_dir = joinpath(project_path, "docs/src/generated/")
!ispath(tutorial_output_dir) && mkdir(tutorial_output_dir)
@info "Literate: create temp dir at $tutorial_output_dir"
tutorial_output_dir_name = splitpath(tutorial_output_dir)[end]

pages = [
    "Home" => "index.md",
    "Phase Space Points" => "phase_space_point.md",
    "Tutorials" => [
        "Four Momentum" => joinpath(tutorial_output_dir_name, "four_momentum.md"),
        "Lorentz Vectors" => joinpath(tutorial_output_dir_name, "lorentz_vectors.md"),
        "Particles" => joinpath(tutorial_output_dir_name, "particle.md"),
        "Stateful Particles" =>
            joinpath(tutorial_output_dir_name, "particle_stateful.md"),
        "Physics Model" => joinpath(tutorial_output_dir_name, "model.md"),
        "Scattering Process" => joinpath(tutorial_output_dir_name, "process.md"),
        "Phase Space Points" =>
            joinpath(tutorial_output_dir_name, "phase_space_point.md"),
    ],
    "API reference" => [
        "Contents" => joinpath("library", "outline.md"),
        "Lorentz vectors" => joinpath("library", "lorentz_vector.md"),
        "Dirac tensors" => joinpath("library", "dirac_objects.md"),
        "Particles" => joinpath("library", "particles.md"),
        "Scattering process" => joinpath("library", "process.md"),
        "Phase space layout" => joinpath("library", "phase_space_layout.md"),
        "Phase space description" => joinpath("library", "phase_space.md"),
        "Probability and cross section" => joinpath("library", "cross_section.md"),
        "Testing functionality" => joinpath("library", "mocks.md"),
        "Function index" => joinpath("library", "function_index.md"),
    ],
    "refs.md",
]

try
    # generate markdown files with Literate.jl
    for file in literate_paths
        Literate.markdown(file, tutorial_output_dir; documenter=true)
    end

    # generate docs with Documenter.jl
    makedocs(;
        modules=[QEDbase],
        checkdocs=:exports,
        authors="Uwe Hernandez Acosta",
        repo=Documenter.Remotes.GitHub("QEDjl-project", "QEDbase.jl"),
        sitename="QEDbase.jl",
        format=Documenter.HTML(;
            prettyurls=get(ENV, "CI", "false") == "true",
            canonical="https://qedjl-project.gitlab.io/QEDbase.jl",
            assets=String[],
            mathengine=Documenter.MathJax2(),
            collapselevel=1,
            # TODO: workaround
            # should be fixed: https://github.com/QEDjl-project/QEDbase.jl/issues/4
            size_threshold_ignore=["index.md"],
        ),
        pages=pages,
        plugins=[bib, links],
    )
finally
    # doing some garbage collection
    @info "GarbageCollection: remove generated landing page"
    rm(index_path)
    @info "GarbageCollection: remove generated tutorial files"
    rm(tutorial_output_dir; recursive=true)
end

deploydocs(; repo="github.com/QEDjl-project/QEDbase.jl.git", push_preview=false)


using Pkg

# targeting the correct source code
# this asumes the make.jl script is located in QEDbase.jl/docs
project_path = Base.Filesystem.joinpath(Base.Filesystem.dirname(Base.source_path()), "..")
Pkg.develop(; path=project_path)

using Documenter
using DocumenterCitations

using QEDbase
using QEDcore
using QEDprocesses

bib = CitationBibliography(joinpath(@__DIR__, "Bibliography.bib"))

# some paths for links
readme_path = joinpath(project_path, "README.md")
index_path = joinpath(project_path, "docs/src/index.md")
license_path = "https://github.com/QEDjl-project/QEDbase.jl/blob/main/LICENSE"

# Copy README.md from the project base folder and use it as the start page
open(readme_path, "r") do readme_in
    readme_string = read(readme_in, String)

    # replace relative links in the README.md 
    readme_string = replace(
        readme_string,
        "[MIT](LICENSE)" => "[MIT]($(license_path))",
    )

    open(index_path, "w") do readme_out
        write(readme_out, readme_string)
    end
end

pages = [
    "Home" => "index.md",
    "Dirac Tensors" => "dirac_tensors.md",
    "Lorentz Vectors" => "lorentz_vectors.md",
    "Four Momenta" => "four_momenta.md",
    "API reference" => [
        "Contents" => "library/outline.md",
        "Lorentz vectors" => "library/lorentz_vector.md",
        "Dirac vectors & matrices" => "library/dirac_objects.md",
        "Particles" => "library/particles.md",
        "Scattering process" => "library/process.md",
        "Computaional model" => "library/model.md",
        "Phase space description" => "library/phase_space.md",
        "Probability and cross section" => "library/cross_section.md",
        "Function index" => "library/function_index.md",
    ],
    "refs.md",
]

try
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
                                    # TODO: workaround
                                    # should be fixed: https://github.com/QEDjl-project/QEDbase.jl/issues/4
                                    size_threshold_ignore=["index.md"],
                                    ),
             pages=pages,
             plugins=[bib],
             )
finally
    @info "Garbage collection: remove landing page"
    rm(index_path)
end

# doing some garbage collection

deploydocs(; repo="github.com/QEDjl-project/QEDbase.jl.git", push_preview=false)

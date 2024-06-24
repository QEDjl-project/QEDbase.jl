
using Pkg

# targeting the correct source code
# this asumes the make.jl script is located in QEDbase.jl/docs
project_path = Base.Filesystem.joinpath(Base.Filesystem.dirname(Base.source_path()), "..")
Pkg.develop(; path=project_path)

using Documenter
using QEDbase

#DocMeta.setdocmeta!(QEDbase, :DocTestSetup, :(using QEDbase); recursive=true)

# TODO: remove before release
Pkg.add(; url="https://github.com/QEDjl-project/QEDcore.jl", rev="dev")

using DocumenterCitations

bib = CitationBibliography(joinpath(@__DIR__, "Bibliography.bib"))

pages = [
    "Home" => "index.md",
    "Dirac Tensors" => "dirac_tensors.md",
    "Lorentz Vectors" => "lorentz_vectors.md",
    "Four Momenta" => "four_momenta.md",
    "Library" => [
        "Contents" => "library/outline.md",
        "API" => "library/api.md",
        "Function index" => "library/function_index.md",
    ],
    "refs.md",
]

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
    ),
    pages=pages,
    plugins=[bib],
)
deploydocs(; repo="github.com/QEDjl-project/QEDbase.jl.git", push_preview=false)

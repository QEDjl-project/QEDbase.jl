
using Documenter
using QEDbase

#DocMeta.setdocmeta!(QEDbase, :DocTestSetup, :(using QEDbase); recursive=true)

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

makedocs(
    modules=[QEDbase],
    checkdocs=:exports,
    authors="Uwe Hernandez Acosta",
    repo="https://gitlab.hzdr.de/hernan68/QEDbase.jl/blob/{commit}{path}#{line}",
    sitename="QEDbase.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://hernan68.gitlab.io/QEDbase.jl",
        assets=String[],
    ),
    pages=pages,
    plugins = [bib]
)

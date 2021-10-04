using QEDbase
using Documenter

DocMeta.setdocmeta!(QEDbase, :DocTestSetup, :(using QEDbase); recursive=true)

makedocs(;
    modules=[QEDbase],
    authors="Uwe Hernandez Acosta",
    repo="https://gitlab.hzdr.de/hernan68/QEDbase.jl/blob/{commit}{path}#{line}",
    sitename="QEDbase.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://hernan68.gitlab.io/QEDbase.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

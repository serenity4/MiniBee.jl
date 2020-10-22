using Documenter, MiniBee

makedocs(;
    modules=[MiniBee],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/serenity4/MiniBee.jl/blob/{commit}{path}#L{line}",
    sitename="MiniBee.jl",
    authors="serenity4 <cedric.bel@hotmail.fr>",
    assets=String[],
)

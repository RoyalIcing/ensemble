defmodule Ensemble.MixProject do
  use Mix.Project

  @source_url "https://github.com/RoyalIcing/ensemble"

  def project do
    [
      app: :ensemble,
      version: "0.0.1",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "ARIA roles helper for testing Phoenix LiveView",
      package: package(),

      # Docs
      name: "ensemble",
      docs: docs(),
      source_url: @source_url,
      homepage_url: "https://icing.space/"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.19 or ~> 0.20"},
      {:floki, ">= 0.30.0", only: :test},
      {:ex_doc, "~> 0.31.2", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      name: :ensemble,
      maintainers: ["Patrick George Wyndham Smith"],
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      # main: "ensemble",
      # logo: "orb-logo-blue-orange.svg",
      extras: [
        "README.md"
      ]
    ]
  end
end

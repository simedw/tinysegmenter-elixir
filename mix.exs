defmodule TinySegmenter.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/simedw/tinysegmenter-elixir"

  def project do
    [
      app: :tinysegmenter,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "TinySegmenter",
      source_url: @source_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "An extremely compact Japanese tokenizer. Elixir port of TinySegmenter by Taku Kudo."
  end

  defp package do
    [
      name: "tinysegmenter",
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["BSD-3-Clause"],
      links: %{
        "GitHub" => @source_url,
        "Original TinySegmenter" => "https://tinysegmenter.tuxfamily.org/"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end

defmodule MinimogameElixir.MixProject do
  use Mix.Project


  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  def deps do
    [
      {:ranch, "~> 1.4"},
      {:distillery, "~> 1.5", runtime: false},
      {:poolboy, "~> 1.5"},
      {:jason, "~> 1.0"},
      {:gen_stage, "~> 0.13"},
    ]
  end
end

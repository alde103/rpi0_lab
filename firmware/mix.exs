defmodule Rpi0Lab.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :rpi0_lab,
      version: "0.1.0",
      elixir: "~> 1.7",
      target: @target,
      archives: [nerves_bootstrap: "~> 1.0"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      start_permanent: Mix.env() == :prod,
      build_embedded: @target != "host",
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Rpi0Lab.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.3", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "0.5.0"}
    ] ++ deps(@target)
  end

  # Specify target specific dependencies
  defp deps("host") do
    [
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.0"},
    ]
  end

  defp deps(target) do
    [
      {:nerves_init_gadget, "~> 0.5.2"},
      {:nerves_network, "~> 0.5.0"},
      {:nerves_neopixel, github: "valiot/nerves_neopixel", branch: "100-dev", submodules: true},
      {:nerves_runtime, "~> 0.6"},
      {:snapex7, "~> 0.1.0"},
      {:toolshed, "~> 0.2.0"},
      {:ng_can, github: "johnnyhh/ng_can", branch: "master"},
      #{:snapex7, github: "valiot/snapex7", branch: "makefile_test", submodules: true}
      #{:snapex7, github: "valiot/snapex7", branch: "Nerves", submodules: true}
      #{:snapex7, path: "/home/alde/Documents/Elixir/repos/snapex7"}
    ] ++ system(target)
  end

  defp system("rpi"), do: [{:nerves_system_rpi, "~> 1.0", runtime: false}]
  defp system("rpi0"), do: [{:nerves_system_rpi0, "~> 1.0", runtime: false}]
  defp system("rpi2"), do: [{:nerves_system_rpi2, "~> 1.0", runtime: false}]
  defp system("rpi3"), do: [{:nerves_system_rpi3, "~> 1.0", runtime: false}]
  defp system("bbb"), do: [{:nerves_system_bbb, "~> 1.0", runtime: false}]
  defp system("ev3"), do: [{:nerves_system_ev3, "~> 1.0", runtime: false}]
  defp system("x86_64"), do: [{:nerves_system_x86_64, "~> 1.0", runtime: false}]
  defp system("rpi0_can"), do: [{:rpi0_can, path: "../rpi0_can", runtime: false}]
  defp system(target), do: Mix.raise("Unknown MIX_TARGET: #{target}")
end

defmodule Rpi0LabTest do
  use ExUnit.Case
  doctest Rpi0Lab

  test "greets the world" do
    assert Rpi0Lab.hello() == :world
  end
end

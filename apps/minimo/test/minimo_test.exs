defmodule MinimoTest do
  use ExUnit.Case
  doctest Minimo

  test "greets the world" do
    assert Minimo.hello() == :world
  end
end

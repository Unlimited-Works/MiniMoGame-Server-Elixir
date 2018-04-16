defmodule Minimo.Core.Map do
  use Minimo.Util.Helper

  @doc """
  hold all information in a map
  1. create a map

  """

  def create(atom_type) do
    %{id: ObjectId.encode!(IdServer.new)}
  end


end

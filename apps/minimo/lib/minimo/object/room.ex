defmodule Minimo.Object.Room do
  alias Minimo.Util.IdServer
  alias Minimo.Util.ObjectId
  
  @doc """
  a game room hold not ready users:
  1. create room
  2. join room
  3. leave room
  4. begin a room
  """

  def create(user_id) do
    x = :ets.new()
    :ets.lookup
    %{room_id: IdServer.new |> ObjectId.encode!}
  end
  
  def join(user_id, room_id) do
    
  end
  
end


defmodule Minimo.Router.Sync do
  @doc """
  sync data as frame: every second send 15~30 times
  sync data trigger: verify and send to client

  
  """
  
  
  def apply(proto_id, load_message)

  @doc """
  load_map: {objId:, pos: [x,y,z]}
  """
  def apply("SYNC_POSITION_PROTO", load_map) do
    IO.puts("#{__MODULE__} sync position proto - ")
    IO.inspect("#{load_map}")

    Minimo.Sync.Position.set_pos(load_map["objId"], List.to_tuple(load_map["pos"]))
    
  end

  @doc """
  load_map: {objId:, pos: [x,y,z]}
  """
  def apply("SYNC_XXXX_PROTO", load_map) do
    IO.puts("#{__MODULE__} sync position proto - ")
    IO.inspect("#{load_map}")

    Minimo.Sync.Position.set_pos(load_map["objId"], List.to_tuple(load_map["pos"]))
    
  end
  
end


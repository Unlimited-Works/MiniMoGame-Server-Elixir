defmodule Minimo.Socket.Worker do
  def start_link do
    IO.puts("#{__MODULE__}: start_link begin")
    opts = [port: 8001]
    rst = :ranch.start_listener(:Minimo222, 100, :ranch_tcp, opts,  Minimo.Socket.Hander, [])
    IO.puts("#{__MODULE__}: start_link end")
    {:ok, _} = rst
  end

end

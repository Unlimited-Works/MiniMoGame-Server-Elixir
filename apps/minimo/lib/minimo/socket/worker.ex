defmodule Minimo.Socket.Worker do
  
  def start_link do
    transport_opts = [
      port: 8001,
      max_connections: 3, # concurrent connections
      num_acceptors: 2,
    ]
   
    rst = :ranch.start_listener(:tcp_listener_minimo, :ranch_tcp, transport_opts,  Minimo.Socket.Hander, [])

#     :ranch.set_protocol_options(:tcp_minimo, :reuseaddr, false)
    IO.puts("#{__MODULE__}: start listener")
    {:ok, _} = rst
  end

end


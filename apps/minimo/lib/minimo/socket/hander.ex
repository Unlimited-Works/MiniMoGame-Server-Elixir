defmodule Minimo.Socket.Hander do
  use Agent, Minimo.Socket.Status
  
  @doc """
  handle socket connection, message dispatch socket disconnection and 
  socket map
  """

  
  
  
  def start_link(ref, socket, atom_transport, opts) do
    IO.inspect("#{__MODULE__}.start_link begin - #{inspect(ref)}, #{inspect(socket)}, #{inspect(atom_transport)}, #{inspect(opts)}}")
    
    # pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    # todo: gen_server will timing out and shutting down if no message received???
    {:ok, hander} = Task.Supervisor.start_child(Minimo.Connection.TaskSupervisor, fn -> Minimo.Socket.Hander.init(ref, socket, atom_transport, opts) end) # :init, [ref, socket, transport, opts])
    IO.puts("#{__MODULE__}.start_link hander pid - #{inspect(hander)}")
    IO.puts("#{__MODULE__}.start_link end")
    {:ok, hander}
  end
         
  def init(ref, socket, transport, _Opts = []) do
    IO.puts("#{__MODULE__}.init begin")
    :ok = :ranch.accept_ack(ref)
    IO.puts("#{__MODULE__}.init accept_ack")
    
    ip = get_socket_ip(socket)
    IO.puts("#{__MODULE__}.init remote ip - #{ip}")
    
    # when socket connection
    on_connect(socket, ip)

    # :begin is first byte which decided the following message protocol
    # every message could define different protocol
    loop(ref, socket, transport, {:begin, 1})
    IO.puts("#{__MODULE__}.init end")
  end

  
  def loop(ref, socket, transport, {state, length}) do
    case transport.recv(socket, length, 100 * 365 * 24 * 60 * 60 * 1000) do
      {:ok, data} ->
	IO.puts("#{__MODULE__}.loop ok begin")
	# 修改该模块的代码，会重启socket链接，因为socket链接的进程调用了loop。所以连接模块的代码和业务逻辑的代码应该分开，业务逻辑的代码保持restful，确保热更新重启时不会导致运行时环境出问题。
	case Minimo.Socket.Router.dispatch(socket, transport, data, state, length) do
	  {:ok, new_state, new_length} ->
	    Minimo.Socket.Hander.loop(ref, socket, transport, {new_state, new_length})
	  {:error, reason} ->
	    transport.close(socket)
	    :ranch.remove_connection(ref)
	    IO.puts("#{__MODULE__}.loop close socket - #{inspect socket}, #{inspect reason}")
	end
	  
        
	# IO.puts("#{__MODULE__}.loop ok end")
      other ->
	IO.puts("#{__MODULE__}.loop - #{inspect(other)}")
	on_disconnect(socket)
	#on_disconnect(socket)
        :ok = transport.close(socket)
	:ranch.remove_connection(ref)
    end
  end


  ## others
  
  def on_connect(socket, ip) do
    # todo there will be :error in actually if client disconnect by TCP/IP layer and reconnect with same port.We should disconnect old connection and prepare new connection.  
     :ok = Minimo.Socket.Status.create(socket, ip)
    
  end

  def on_disconnect(socket) do
    Minimo.Socket.Status.delete(socket)
  end

  defp get_socket_ip(socket) do
    {:ok, {ipAddress, ipPort}} = :inet.peername(socket)
    "#{Enum.join(Tuple.to_list(ipAddress), ".")}:#{ipPort}"
  end
  
end


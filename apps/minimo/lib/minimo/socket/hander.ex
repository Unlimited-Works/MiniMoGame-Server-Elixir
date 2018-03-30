defmodule Minimo.Socket.Hander do
 # use Agent, restart: :temporary
  
  def start_link(ref, socket, transport, opts) do
    IO.puts("#{__MODULE__}.start_link begin")
    # pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    # todo: gen_server will timing out and shutting down if no message received???
    {:ok, pid} = Task.Supervisor.start_child(Minimo.Connection.TaskSupervisor, fn -> Minimo.Socket.Hander.init(ref, socket, transport, opts) end) # :init, [ref, socket, transport, opts])
    IO.inspect(pid)
    IO.puts("#{__MODULE__}.start_link end")
    {:ok, pid}
  end
         
  def init(ref, socket, transport, _Opts = []) do
    IO.puts("#{__MODULE__}.init begin")
    :ok = :ranch.accept_ack(ref)
    IO.puts("#{__MODULE__}.init accept_ack")
    loop(socket, transport)
    IO.puts("#{__MODULE__}.init end")
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 100 * 365 * 24 * 60 * 60 * 1000) do
      {:ok, data} ->
	IO.puts("#{__MODULE__}.loop ok begin")
	# 修改该模块的代码，会重启socket链接，因为socket链接的进程调用了loop。所以连接模块的代码和业务逻辑的代码应该分开，业务逻辑的代码保持restful，确保热更新重启时不会导致运行时环境出问题。
	Minimo.Socket.Router.dispatch(socket, transport, data)
        Minimo.Socket.Hander.loop(socket, transport)
	# IO.puts("#{__MODULE__}.loop ok end")
      _ ->
	IO.puts("#{__MODULE__}.loop _")
        :ok = transport.close(socket)
	
    end
  end

end

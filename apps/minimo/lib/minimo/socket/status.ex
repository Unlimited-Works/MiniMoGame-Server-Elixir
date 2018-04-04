defmodule Minimo.Socket.Status do
  use GenServer

  @doc """
  maintains sockets by ip
  """
  
  ## Client API

  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  def start_link(opts) do
    # 1. Pass the name to GenServer's init
    server = Keyword.fetch!(opts, :name)
    rst = GenServer.start_link(__MODULE__, :ok, opts)
    IO.puts("#{__MODULE__}.start_link")
    rst
  end

  @doc """

  """
  def lookup(socket) do
    # 2. Lookup is now done directly in ETS, without accessing the server
    case :ets.lookup(__MODULE__, socket) do
      [{^socket, ip}] -> {:ok, ip}
      [] -> :error
    end
  end

  @doc """
  
  """
  def create(socket, ip) do
    GenServer.call(__MODULE__, {:create, socket, ip})
  end

  def delete(socket) do
    GenServer.call(__MODULE__, {:delete, socket})
  end
  
  ## Server callbacks

  def init(:ok) do
    # 3. We have replaced the names map by the ETS table
    atom_table_socket = :ets.new(__MODULE__, [:named_table, read_concurrency: true])
    #refs  = %{}
    {:ok, atom_table_socket}
  end

  # 4. The previous handle_call callback for lookup was removed

  def handle_call({:create, socket, ip}, _from, atom_table_socket) do
    # 5. Read and write to the ETS table instead of the map
    case lookup(socket) do
      {:ok, ip} ->
        {:reply, {:error, :has_exist}, atom_table_socket}
      :error ->
        :ets.insert(__MODULE__, {socket, ip})
        {:reply, :ok, atom_table_socket}
    end
  end

  def handle_call({:delete, socket}, _from, atom_table_socket) do
    true = :ets.delete(__MODULE__, socket)
    {:reply, true, atom_table_socket}
  end

#  def handle_info({:DOWN, ref, :process, _pid, _reason}, atom_table_socket) do
    # 6. Delete from the ETS table instead of the map
#    {name, refs} = Map.pop(refs, ref)
#    :ets.delete(names, name)
#    {:noreply, atom_table_socket}
#  end

#  def handle_info(_msg, state) do
#    {:noreply, state}
#  end
end

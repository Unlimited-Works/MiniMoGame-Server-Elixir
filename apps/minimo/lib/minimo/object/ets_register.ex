defmodule Minimo.Object.ETSRegister do
  use GenServer
  
  require Logger

  
  @doc """
  save all ets used in scene and reference it to a string name
  """
  def start_link(opts) do
    Logger.info "#{__MODULE__} start link"

    GenServer.start_link(__MODULE__, :ok, opts)
    # Supervisor.child_spec({__MODULE__, init}, opts)
  end
  
  def new_ets(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, cur_ref}] ->
	{:error, "#{name} - has exist"}
      [] ->
	ref = :ets.new(:a, [
	    :set,
	    :public,
	    read_concurrency: true,
	    write_concurrency: true
	  ])
	:ets.insert(__MODULE__, {name, ref})
	
	{:ok, ref}
    end
    # {:ok, ref} = GenServer.call(__MODULE__, {:new_ets, name})
    
  end

  def del_ets(name) do
    # {:ok, ref} = GenServer.call(__MODULE__, {:del_ets, name})
    case :ets.lookup(__MODULE__, name) do
      [{^name, ref}] ->
	true = :ets.delete(__MODULE__, name)
  {:ok, ref}
      other ->
	{:error, "result not match - #{inspect(other)}"}
    end
    
  end

  def get_ref(name) do
    case :ets.lookup(__MODULE__, name) do
      [] -> {:error, "not exist"}
      [x] -> {:ok, x}
    end
  end
  
  def init(:ok) do
    atom_reg_name = :ets.new(__MODULE__, [:named_table,
			  :set,
			  :public,
			  write_concurrency: true,
			  read_concurrency: true])
    {:ok, atom_reg_name}
  end

#  
#  def handle_call({:new_ets, name}, _from, state) do
#    case :ets.lookup(__MODULE__, name) do
#      [{^name, cur_ref}] ->
#	{:reply, {:error, "#{name} - has exist"}, state}
#      [] ->
#	ref = :ets.new(:a, [
#	    :set,
#	    :public,
#	    read_concurrency: true,
#	    write_concurrency: true
#	  ])
#	:ets.insert(__MODULE__, {name, ref})
#	
#	{:reply, {:ok, ref}, state}
#    end
#    
#  end
#
#  def handle_call({:del_ets, name}, _from, state) do
#    case :ets.lookup(__MODULE__, name) do
#      [{^name, ref}] ->
#	true = :ets.delete(__MODULE__, name)
#	{:reply, {:ok, ref}, state}
#      other ->
#	{:reply, {:error, "result not match - #{inspect(other)}"}, state}
#    end
#    
#  end
#  
  
end

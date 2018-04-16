defmodule Minimo.Core.Map.NameRegisterMap do
  @doc """
  每个地图都需要维护一系列的数据保证地图的数据是可以高效访问和更新的。这些数据通过索引关联起来，
  每种索引及其相关的数据通过ets关联起来，包括位置索引——某一位置上的
  """

  use GenServer

  require Logger
  alias Minimo.Object.Map.WriteAtom

  @doc """
  save all ets used in scene and reference it to a string name
  """
  def start_link(opts) do
    Logger.info("#{__MODULE__} start link")

    GenServer.start_link(__MODULE__, :ok, opts)
    # Supervisor.child_spec({__MODULE__, init}, opts)
  end

  @doc """
  创建一个房间所需要的所有ets，并同过str_name来关联这些信息
  """
  def new(id) do
    GenServer.call(__MODULE__, {:new, id})
  end

  def del(id) do
    GenServer.call(__MODULE__, {:del, id})
  end

  def get(id) do
    case :ets.lookup(__MODULE__, id) do
      [] -> {:error, "not exist"}
      [x] -> {:ok, x}
    end
  end

  def init(:ok) do
    atom_reg_name =
      :ets.new(__MODULE__, [
        :named_table,
        :set,
        :public,
        write_concurrency: true,
        read_concurrency: true
      ])

    {:ok, atom_reg_name}
  end

  def handle_call({:new, name}, from, state) do
    rst =
      case :ets.lookup(__MODULE__, name) do
        [{^name, cur_refs}] ->
          {:error, "#{name} - has exist"}

        [] ->
          ref1 =
            :ets.new(:a, [
              :set,
              :public,
              read_concurrency: true,
              write_concurrency: true
            ])

          ref2 =
            :ets.new(:a, [
              :set,
              :public,
              read_concurrency: true,
              write_concurrency: true
            ])

          {:ok, pid} = WriteAtom.new()

          refs = {ref1, ref2, pid}
          :ets.insert(__MODULE__, {name, refs})

          {:ok, refs}
      end

    {:reply, rst}
  end

  def handle_call({:del, name}, from, state) do
    # {:ok, ref} = GenServer.call(__MODULE__, {:del_ets, name})
    rst =
      case :ets.lookup(__MODULE__, name) do
        [{^name, ref}] ->
          true = :ets.delete(__MODULE__, name)
          {:ok, ref}

        other ->
          {:error, "result not match - #{inspect(other)}"}
      end

    {:reply, rst}
  end
end

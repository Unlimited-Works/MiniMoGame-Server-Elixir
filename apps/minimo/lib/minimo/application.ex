defmodule Minimo.Application do
  use Application
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      {Task.Supervisor, name: Minimo.Connection.TaskSupervisor},
      :poolboy.child_spec(:msg_hander, poolboy_config()),
      worker(Minimo.Socket.Worker, []),
      {Minimo.Sync.Position , name: Minimo.Sync.Position},
      {Minimo.Socket.Status, name: Minimo.Socket.Status},
      {Minimo.Util.IdServer, name: Minimo.Util.IdServer},
      {Minimo.Object.ETSRegister, name: Minimo.Object.ETSRegister},
      # supervisor(Registry, [:unique, :registry_ets_ref]),
    ]

 #   opts = [strategy: :one_for_one, name: Minimo.TaskSupervisor]
    opts = [strategy: :one_for_one]
    rst = Supervisor.start_link(children, opts)

    IO.puts("#{__MODULE__}: start applications")

    rst
  end
  
  # used at deal with message
  defp poolboy_config do
    [
      {:name, {:local, :msg_hander}},
      {:worker_module, Minimo.Socket.MsgHander},
      {:size, 10},
      {:max_overflow, 2}
    ]
  end

end

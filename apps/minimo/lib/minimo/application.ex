defmodule Minimo.Application do
  use Application

  # used at deal with message
  defp poolboy_config do
    [
      {:name, {:local, :msg_hander}},
      {:worker_module, Minimo.Socket.MsgHander},
      {:size, 10},
      {:max_overflow, 2}
    ]
  end

  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts("#{__MODULE__}: start begin")
    children = [
      {Task.Supervisor, name: Minimo.Connection.TaskSupervisor},
      :poolboy.child_spec(:msg_hander, poolboy_config()),
      worker(Minimo.Socket.Worker, [])

    ]

    opts = [strategy: :one_for_one, name: Minimo.TaskSupervisor]
    rst = Supervisor.start_link(children, opts)

    IO.puts("#{__MODULE__}: start end")

    rst
  end
end

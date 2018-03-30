defmodule Minimo.Router.Login do
  @timeout 60000 # 1 min

  # return: {:end/:error/:on, :once/:stream, json_map}
  def apply(proto_id, load_message)
  
  def apply("LOGIN_PROTO", load_map) do
    IO.puts "#{__MODULE__}.apply - "
    IO.inspect load_map
#    {:end, :once, %{"accountId" => "account001"}}

    {:end, :once, true}#%{"accountId" => "account001"}}
    
  end
  
  def start do
    1..20
    |> Enum.map(fn i -> async_call_square_root(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp async_call_square_root(i) do
    Task.async(fn ->
      :poolboy.transaction(
        :msg_hander,
        fn pid -> GenServer.call(pid, {:square_root, i}) end,
        @timeout
      )
    end)
  end


  
  defp await_and_inspect(task), do: task |> Task.await(@timeout) |> IO.inspect()
end

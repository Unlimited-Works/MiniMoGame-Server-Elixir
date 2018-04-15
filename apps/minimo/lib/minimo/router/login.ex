defmodule Minimo.Router.Login do
  
  # return: {:end/:error/:on, :once/:stream, json_map}
  def apply(proto_id, load_message)
  
  def apply("LOGIN_PROTO", load_map) do
    IO.puts "#{__MODULE__}.apply - "
    IO.inspect load_map
#    {:end, :once, %{"accountId" => "account001"}}

    {:end, :once, true}#%{"accountId" => "account001"}}
    
  end

  
end

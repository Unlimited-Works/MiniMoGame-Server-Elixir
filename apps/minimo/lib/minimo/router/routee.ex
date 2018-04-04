defmodule Minimo.Router.Routee do

  @routers %{
    "login" =>  Minimo.Router.Login,
    "sync" => Minimo.Router.Sync,
  }
  
  def get_module(str_name) do
    @routers[str_name]
  end

end

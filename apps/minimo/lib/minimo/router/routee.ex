defmodule Minimo.Router.Routee do

  @routers %{
    "login" => Minimo.Router.Login,
      
  }
  
  def get_module(name) do
    @routers[name]
  end
  
end


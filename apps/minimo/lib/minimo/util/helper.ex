defmodule Minimo.Util.Helper do
  defmacro __using__(_opts) do
    quote do
      alias Minimo.Util.IdServer
      alias Minimo.Util.ObjectId

    end
    
  end
  
end


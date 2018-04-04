defmodule Minimo.Object.Map.Kongfu do
  use Minimo.Util.Helper
  use GenServer
  
  @doc """
  kongfu map:
  1. map's view
  |x|_|x|
  |o|x|x|
  |_|x|o|
  2. role's init position
  3. setting two ets's infomation: when role moving/die or some object 
     be eat or some role generate a boom.(NOTICE: those operation should check game status for anti-cheat)
  4. 
  """

  @doc """
  create a new kongfu map, contains all objects in the map.
  use two ets tables: 
    1. for map view: `{x, y, z} => objId`
    2. objects info `objId => %{info...}`
  
  params: 
  ```
  roles: [
    {
      id: ...,
      type: ...,
      name: ...
      (pos: {x,y,z}) # fill in
    },
    ...
  ]

  infos: %{
    

  }
  ```
  """
  def create(roles) do
    id = ObjectId.encode!(IdServer.new)
    table_map = :ets.new(:"#{__MODULE__}.map.#{id}", [:named_table, read_concurrency: true])
    table_objs = :ets.new(:"#{__MODULE__}.objs.#{id}", [:named_table, read_concurrency: true])
    
    # init roles

    # append postion initalize
    newRoles = for role <- roles do
      # todo: setting position {0,0,0} with custom value
      Map.put(role, "pos", {0,0,0}) 
    end

    for role <- Enum.with_index(newRoles) do
      # build map view
      :ets.insert(table_map, {{0,0,0}, role})

      ## todo: build other object to the map
      ## notice: if no position defined in the map means it's moveable  

      # build indexes
  
      ## setting role's information
      :ets.insert(table_objs, {role["id"], role})
      
    end

    table_map
    
  end

  @doc """
  table_map = create(roles) 
  update(table_map, obj_id, fn item -> unit end)
  """
  def update(table_map, obj_id, f) do
    :ets.update_element
  end
  
  
end


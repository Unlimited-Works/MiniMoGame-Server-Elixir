defmodule Minimo.Core.Map.NormalMap do
  use Minimo.Util.Helper

  alias Minimo.Object.ETSRegister
  alias Minimo.Object.Map.NameRegisterMap
  alias Minimo.Object.Map.WriteAtom

  # static
  @table_map "#{__MODULE__}.map"
  @table_objs "#{__MODULE__}.objs"

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

  ```
  """
  def create(roles) do
    id = ObjectId.encode!(IdServer.new)

    # create table
    {:ok, {ref_map, ref_objs, pid_write}} = NameRegisterMap.new(id)

   # {:ok, ref_map} = ETSRegister.new_ets("#{@table_map}.#{id}")
   # {:ok, ref_objs} = ETSRegister.new_ets("#{@table_objs}.#{id}")

    # 这个进程专门为原子性的写操作创建的，防止ABA并发问题
   # {:ok, write_server} = DynamicSupervisor.start_child(MapDynamicSupervisor, Minimo.Object.Map.NormalMap.WriteAtom)



    # init roles

    # append postion initalize
    newRoles = for role <- roles do
      # todo: setting position {0,0,0} with custom value
      Map.put(role, "pos", {0,0,0})
    end

    for role <- Enum.with_index(newRoles) do
      # build map view这是位置
      :ets.insert(ref_map, {{0,0,0}, role["id"]})

      ## todo: build other object to the map
      ## notice: if no position defined in the map means it's moveable

      # build indexes


      ## setting role's information
      :ets.insert(ref_objs, {role["id"], role})

    end

    id

  end

  @doc """

  table_map = create(roles)
  update(table_map, obj_id, fn item -> unit end)

  # update should be sequence for avoid ABA
  best lock is lock by obj_id
  """
  def update_obj(id, obj_id, f) do
    {:ok, {table_map, table_obj, pid_write}} = NameRegisterMap.get(id)
    WriteAtom.update(table_obj, obj_id, f)
  end

  @doc """
  delete the room
  """
  def destory(id) do
    #ETSRegister.del_ets("#{@table_map}.#{id}")
    #ETSRegister.del_ets("#{@table_objs}.#{id}")
    {:ok, {table_map, table_obj, pid_write}} = NameRegisterMap.get(id)
    :ets.delete table_map
    :ets.delete table_obj
    WriteAtom.delete(pid_write)
    NameRegisterMap.del(id)
  end


end


defmodule Minimo.Router.Room do
  require Minimo.
  @doc """
  登陆之后，用户可以创建一个Room。
  一个Room对应这些功能：
  1. 创建房间 PROTO_ROOM_CREATE
  2. 离开房间 PROTO_ROOM_LEAVE
  3. 开始游戏 PROTO_ROOM_BEGIN
  4. 选择地图 PROTO_ROOM_CHOICE_MAP
  5. 选择角色 PROTO_ROOM_CHOICE_ROLE
  6. 准备完毕 PROTO_ROOM_READY
  7. 取消准备 PROTO_ROOM_READY_CANCEL

  使用场景举例：
  一个房间最多有8个用户，创建房间的用户为房主，当每个用户都准备完毕后，房主可以控制游戏的开始。
  当房主离开后，第二个加入的玩家会被重新认定为房主。当房间中的最后一个玩家退出房间后，销毁房间。
  玩家在准备后，不可以更换角色。
  """

  @PROTO_ROOM_CREATE PROTO_ROOM_CREATE
  @PROTO_ROOM_LEAVE PROTO_ROOM_LEAVE
  @PROTO_ROOM_BEGIN PROTO_ROOM_BEGIN
  @PROTO_ROOM_CHOICE_MAP PROTO_ROOM_CHOICE_MAP
  @PROTO_ROOM_CHOICE_ROLE PROTO_ROOM_CHOICE_ROLE
  @PROTO_ROOM_READY PROTO_ROOM_READY
  @PROTO_ROOM_READY_CANCEL PROTO_ROOM_READY_CANCEL


  @doc """
  load_map:
  {
    type: normal/kongfu/... 创建哪种类型的地图，默认为normal
  }

  load_map可以为nil，表示使用normal模式的地图。（为了减少服务器端的复杂度，将边界代码放在客户端处理）
  """
  def apply(@PROTO_ROOM_CREATE, load_map) do
    IO.puts "#{__MODULE__}.apply - #{inspect(load_map)}"

    
    {:end, :once, %{"state" => 200, "load" => %{"room_id" => "id001"}}}
    
  end
  
end

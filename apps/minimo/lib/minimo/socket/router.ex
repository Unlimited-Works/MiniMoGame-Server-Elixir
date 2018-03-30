defmodule Minimo.Socket.Router do

  def dispatch(socket, transport, data) do
    :poolboy.transaction(
      :msg_hander,
      fn pid ->
	case data do
#	  GenServer.call(pid, {:request, })
	  <<1::size(8), length::big-32, jsonb::binary>> ->
	    {task_id, load} = json_proto1(socket, transport, jsonb)
	    {atom_status, atom_type, map_logic_rst} = GenServer.call(pid, {:request, load})
	    map_rst = %{
	      "taskId" => task_id,
	      "type" => Atom.to_string(atom_type),
	      "status" => Atom.to_string(atom_status),
	      "load" => map_logic_rst
	    }

	    # debug
	    IO.puts "#{__MODULE__}.dispath map_rst"
	    IO.inspect map_rst
	    
	    json_rst = Jason.encode!(map_rst)
	    bit_length = byte_size(json_rst)
	    bit_final_rst = <<1::size(8), bit_length::big-32, json_rst::binary>>
	    
	    transport.send(socket, bit_final_rst)
	  
	  <<2::size(8), length::big-32, normalData::binary>> ->
	    normalProto2(socket, transport, normalData)

	  _ ->
	    unknowProto(socket, transport, data)
	end
	
#	rst = GenServer.call(pid, {:square_root, 4})
#	rst =  <<?2, 1::big-32, ?a>>
#	transport.send(socket, rst)
      end,
      20 * 1000 #timeout mills
    )
  end
  
  @doc ~S"""
  use process pool to handle data, this is main protocol
  """
  def json_proto1(socket, transport, jsonb) do
    	
    IO.puts("#{__MODULE__}.dispatcher1 - ")
    IO.puts("socket get json data - #{IO.inspect(jsonb)}")
   
    # Jason.encode!()
    json = Jason.decode!(jsonb)
    %{
      "taskId" => taskId,
      "load" => load
#	%{
#	  "path" => path,
#	  "protoId" => protoId,
#	  "load" => load
#	},
    } = json

    {taskId, load}

  end

  @doc ~S"""
  use process pool to handle data
  """
  def normalProto2(socket, transport, <<2::size(8), length::big-32, data::binary>>) do
   
    IO.puts("#{__MODULE__}.dispatcher2 - ")
    IO.puts("socket get normal data - #{IO.inspect(data)}")
    #transport.send(socket, <<2::size(8), length::big-32, data::binary>>)
  end
  
  def unknowProto(socket, transport, undefined) do
    IO.puts("#{__MODULE__}.dispatcher0 socket get undefined data - ")
    # todo why undefined print as:
    # ```
    # <<2, 0, 0, 0, 13, 104, 101, 108, 108, 111, 32, 115, 101, 114, 118, 101, 114, 33>>
    # hello server! <--- IO.inspect可以识别出协议中字符串？
    # ```
    IO.puts(IO.inspect(undefined))
  end

  
end

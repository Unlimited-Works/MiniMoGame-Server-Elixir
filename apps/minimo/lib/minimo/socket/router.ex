defmodule Minimo.Socket.Router do

  def dispatch(socket, transport, data, state, _byte_length) do
    IO.puts("#{__MODULE__}.dispatch state - #{state}")
    
    # decide protocol by first byte
    case state do
      :begin -> # decide protocol for the message
	<<int_data::size(8)>> = data
	cond do
	  int_data == 1 ->
	    {:ok, :p1_length, 4}
	  int_data == 2 ->
	    {:ok, :p2_length, 4}
	  true ->
	    {:error, "undefined protocol - #{int_data}"}
	end
      #
      :p1_length ->
	<<int_data::big-32>> = data
	if int_data <= 1024 * 10 do # message load should be less then 10KB
	  {:ok, :p1_load, int_data}
	else
	  {:error, "message length to long - #{state}, #{int_data}"}
	end
      :p2_length ->
	<<int_data::big-32>> = data
	if int_data <= 1024 * 10 do # message load should be less then 10KB
	  {:ok, :p2_load, int_data}
	else
	  {:error, "message length to long - #{state}, #{int_data}"}
	end
      :p1_load ->
	handle_proto1_load(socket, transport, data)
        {:ok, :begin, 1}
      :p2_load ->
	handle_proto2_data(socket, transport, data)
        {:ok, :begin, 1}
      other ->
	{:error, "unknow state - #{other}"}
    end
    
	
    
#    :poolboy.transaction(
#      :msg_hander,
#      fn pid ->
#	case data do
#	  GenServer.call(pid, {:request, })
#	  <<1::size(8), length::big-32, jsonb::binary>> ->
#	    {task_id, load} = json_proto1(socket, transport, jsonb)
#	    {atom_status, atom_type, map_logic_rst} = GenServer.call(pid, {:request, load})
#	    map_rst = %{
#	      "taskId" => task_id,
#	      "type" => Atom.to_string(atom_type),
#	      "status" => Atom.to_string(atom_status),
#	      "load" => map_logic_rst
#	    }

	    # debug
#	    IO.puts "#{__MODULE__}.dispath map_rst"
#	    IO.inspect map_rst
	    
#	    json_rst = Jason.encode!(map_rst)
#	    bit_length = byte_size(json_rst)
#	    bit_final_rst = <<1::size(8), bit_length::big-32, json_rst::binary>>
	    
#	    transport.send(socket, bit_final_rst)
	  
#	  <<2::size(8), length::big-32, normalData::binary>> ->
	    #normalProto2(socket, transport, normalData)

#	  _ ->
#	    unknowProto(socket, transport, data)
#	end
	
##	rst = GenServer.call(pid, {:square_root, 4})
##	rst =  <<?2, 1::big-32, ?a>>
##	transport.send(socket, rst)
#      end,
#      20 * 1000 #timeout mills
#    )
  end
  
  def json_proto1(jsonb) do
    IO.puts("#{__MODULE__}.dispatcher1 - ")
    IO.puts("socket get json data - #{IO.inspect(jsonb)}")
  
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

  defp handle_proto1_load(socket, transport, jsonb) do
    :poolboy.transaction(
      :msg_hander,
      fn pid ->
	{task_id, load} = json_proto1(jsonb)
	context = %{socket: socket}
        {atom_status, atom_type, map_logic_rst} = GenServer.call(pid, {:request, load, context})
	
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
      end,
      20 * 1000 #timeout mills
    )
  end

  defp handle_proto2_data(_socket, _transport, data) do
    IO.puts("#{__MODULE__}.handle_proto2_data - ")
    IO.inspect(data)
    #transport.send(socket, <<2::size(8), length::big-32, data::binary>>)
  end

end

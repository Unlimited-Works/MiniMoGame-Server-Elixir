# MinimogameElixir
Minimo Game backend build by Elixir Language.

## Run server in REPL
1. download source
2. install dependency: use `mix deps.get` at root of the project
3. run server: `MIX_ENV=test iex -S mix`

## Test login API
1. open another REPL in the project: `MIX_ENV=test iex -S mix`
2. connect to server over tcp:
```
 iex(1)> {:ok, socket} = :gen_tcp.connect 'localhost', 8001, [:binary, active: false]
 {:ok, #Port<0.5078>}
```
3. send by server-client protocol:
```
iex(2)> request_data = %{
...(2)>   "load" => %{
...(2)>     "load" => %{"password" => "admin", "userName" => "admin"},
...(2)>     "path" => "login",
...(2)>     "protoId" => "LOGIN_PROTO"
...(2)>   },
...(2)>   "taskId" => "29482490533798-25"
...(2)> } #define request data
iex(3)> json = Jason.encode! request_data #convert map to string
iex(4)> size = byte_size json #calculate json string bytes
iex(5)> send_rst = :gen_tcp.send socket, <<1::size(8), 125::big-32, json::binary>> #send bytes defined by server-client protocol
```
4. read tcp data from server
```
iex(6)> recv_rst = :gen_tcp.recv socket, 0 #get all data the socket received
iex(7)> {:ok, <<1::size(8), recv_length::big-32, json_rst::binary>>} = recv_rst #extract result structure
iex(8)> Jason.dncode! json_rst #convert json string to map type
%{
  "load" => true,
  "status" => "end",
  "taskId" => "29482490533798-25",
  "type" => "once" 
}
```

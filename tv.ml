
open Core
open C

let init_connection () = let open Option in
  let conn = Connection.init() in
  Connection.connect conn ~port:"RPI" ~timeout:(Unsigned.UInt32.of_int 10000)
  >>= fun () -> return conn

let power_on = let open Option in
  Command.basic ~summary:"Turn the tv on"
  @@ Command.Param.return (fun () ->
      value_exn (init_connection ()
                 >>= fun conn -> Connection.power_on conn 0))

let power_off = let open Option in
  Command.basic ~summary:"Turn the tv off"
  @@ Command.Param.return (fun () ->
      value_exn (init_connection ()
                 >>= fun conn -> Connection.standby conn 0))

let power_toggle = let open Option in
  let toggle () =
    init_connection ()
    >>= fun conn ->
    match Connection.power_status conn 0 with
    | On -> Connection.standby conn 0
    | Standby -> Connection.power_on conn 0
    | _ -> None in
  Command.basic ~summary:"Toggle the power state of the tv"
    @@ Command.Param.return (fun () -> value_exn (toggle()))

let main =
  Command.run ~version:"0.0.1" ~build_info:"Build: xxxx"
  @@ Command.group ~summary:"Control the tv"
    [ "on", power_on;
      "off", power_off;
      "toggle", power_toggle ]

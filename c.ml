
open Ctypes
open Foreign

let wrap_exitcode: int -> unit option = function
  | 1 -> Some ()
  | _ -> None

module Logical_address = struct

  type t = int

end

module Power_status = struct

  type t =
    | On
    | Standby
    | Transition_standby_on
    | Transition_on_standby
    | Unknown

  let to_int = function
    | On -> 0x00
    | Standby -> 0x01
    | Transition_standby_on -> 0x02
    | Transition_on_standby -> 0x03
    | Unknown -> 0x99

  let of_int = function
    | 0x00 -> On
    | 0x01 -> Standby
    | 0x02 -> Transition_standby_on
    | 0x03 -> Transition_on_standby
    | 0x99 -> Unknown
    | _ -> failwith "bad encoding: not a power status"

  let t = view ~read:of_int ~write:to_int int

end

module Connection = struct

  type t = unit ptr
  let t = ptr void

  let init: unit -> t =
    foreign "new_connection"
      (void @-> returning t)

  let connect: t -> port:string -> timeout:Unsigned.uint32 -> unit option =
    fun conn ~port ~timeout ->
    foreign "libcec_open"
      (t @-> string @-> uint32_t @-> returning int)
      conn port timeout
    |> wrap_exitcode

  let power_on (conn: t) (laddr: Logical_address.t): unit option =
    foreign "libcec_power_on_devices"
      (t @-> int @-> returning int)
      conn laddr
    |> wrap_exitcode

  let standby (conn: t) (laddr: Logical_address.t): unit option =
    foreign "libcec_standby_devices"
      (t @-> int @-> returning int)
      conn laddr
    |> wrap_exitcode

  let power_status (conn: t) (laddr: Logical_address.t): Power_status.t =
    foreign "libcec_get_device_power_status"
      (t @-> int @-> returning Power_status.t)
      conn laddr
end

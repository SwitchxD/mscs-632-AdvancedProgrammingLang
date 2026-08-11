(* Mean: sums the list with fold_left, divides by length *)
let mean lst =
  let sum = List.fold_left (+) 0 lst in
  float_of_int sum /. float_of_int (List.length lst)

(* Median: sorts an immutable copy, picks middle value(s) *)
let median lst =
  let sorted = List.sort compare lst in
  let n = List.length sorted in
  let arr = Array.of_list sorted in
  if n mod 2 = 0 then
    float_of_int (arr.(n/2 - 1) + arr.(n/2)) /. 2.0
  else
    float_of_int arr.(n/2)

(* Mode: maps each value to its frequency via filter, keeps the max *)
let mode lst =
  let counts = List.map (fun x -> (x, List.length (List.filter ((=) x) lst))) lst in
  let max_count = List.fold_left (fun acc (_, c) -> max acc c) 0 counts in
  let modes = List.filter (fun (_, c) -> c = max_count) counts in
  List.sort_uniq compare (List.map fst modes)

let () =
  let data = [4; 8; 2; 8; 6; 4; 8; 1] in
  Printf.printf "Data: %s\n" (String.concat " " (List.map string_of_int data));
  Printf.printf "Mean: %.2f\n" (mean data);
  Printf.printf "Median: %.2f\n" (median data);
  Printf.printf "Mode(s): %s\n" (String.concat " " (List.map string_of_int (mode data)))
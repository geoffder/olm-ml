open! Core

let test name bool =
  printf "%s => %s\n" name (if bool then "YES!" else "NO!")

require! {
  fs, \recursive-readdir-sync
  \prelude-ls : {filter, reject, map, each}
}

[
  \src
]
|> each (target)->
  recursive-readdir-sync "./test/#target"
  |> filter (is /\.ls$/)
  |> each (.replace /^test/, \.) >> require


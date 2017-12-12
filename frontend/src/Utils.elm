module Utils exposing (updateById, (>>>), (<<<))


updateById :
    id
    -> ({ a | id : id } -> { a | id : id })
    -> List { a | id : id }
    -> List { a | id : id }
updateById id updateFn =
    List.map
        (\item ->
            if item.id == id then
                updateFn item
            else
                item
        )


{-| Compose a two parameter function with a single parameter function

(foo >>> bar) a b == bar (foo a b)

-}
(>>>) : (a -> b -> c) -> (c -> d) -> a -> b -> d
(>>>) foo bar x y =
    foo x y |> bar


{-| Compose a two parameter function with a single parameter function

(foo <<< bar) a b == foo (bar a b)

-}
(<<<) : (c -> d) -> (a -> b -> c) -> a -> b -> d
(<<<) =
    flip (>>>)

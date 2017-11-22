module Utils exposing (updateById)


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

module Data.Game
    exposing
        ( Game
        , GameId
        , encode
        , decoder
        , setSelection
        )

import Json.Encode
import Json.Decode


type alias Game =
    { selected : Bool
    , id : GameId
    , title : String
    , thumbnail_url : String
    , image_url : String
    , year : Maybe String
    }


type alias GameId =
    String


encode : Game -> Json.Encode.Value
encode game =
    Json.Encode.object
        [ ( "id", Json.Encode.string game.id )
        , ( "title", Json.Encode.string game.title )
        , ( "thumbnail_url", Json.Encode.string game.thumbnail_url )
        , ( "image_url", Json.Encode.string game.image_url )
        , ( "year"
          , game.year
                |> Maybe.map Json.Encode.string
                |> Maybe.withDefault Json.Encode.null
          )
        ]


decoder : Json.Decode.Decoder Game
decoder =
    Json.Decode.map5 (Game True)
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "thumbnail_url" Json.Decode.string)
        (Json.Decode.field "image_url" Json.Decode.string)
        (Json.Decode.field "year" (Json.Decode.maybe Json.Decode.string))


setSelection : Bool -> Game -> Game
setSelection selected game =
    { game | selected = selected }

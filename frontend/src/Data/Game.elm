module Data.Game exposing (Game, encode, decoder)

import Json.Encode
import Json.Decode


type alias Game =
    { id : String
    , name : String
    , thumbnail_url : String
    , image_url : String
    , year : Maybe String
    }


encode : Game -> Json.Encode.Value
encode game =
    Json.Encode.object
        [ ( "id", Json.Encode.string game.id )
        , ( "name", Json.Encode.string game.name )
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
    Json.Decode.map5 (Game)
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "thumbnail_url" Json.Decode.string)
        (Json.Decode.field "image_url" Json.Decode.string)
        (Json.Decode.field "year" (Json.Decode.maybe Json.Decode.string))

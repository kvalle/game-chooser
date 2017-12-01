module Data.Poll exposing (Poll, PollId, encode)

import Data.Game exposing (GameId)
import Json.Encode


type alias Poll =
    List GameId


type alias PollId =
    String


encode : Poll -> Json.Encode.Value
encode poll =
    Json.Encode.object
        [ ( "game_ids", Json.Encode.list <| List.map Json.Encode.string poll )
        ]

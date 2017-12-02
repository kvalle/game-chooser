module Data.Poll exposing (Poll, PollId, decoder)

import Data.Game exposing (GameId, Game)
import Json.Decode
import Dict exposing (Dict)


type alias Poll =
    { id : PollId
    , games : Dict GameId Game
    , votes : Dict Name (List GameId)
    }


type alias PollId =
    String


type alias Name =
    String


decoder : Json.Decode.Decoder Poll
decoder =
    Json.Decode.map3 Poll
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "games" <| Json.Decode.dict <| Data.Game.decoder)
        (Json.Decode.field "votes" <| Json.Decode.dict <| Json.Decode.list Json.Decode.string)

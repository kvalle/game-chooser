module Data.Poll exposing (Poll, PollId, encode, decoder)

import Data.Game exposing (GameId, Game)
import Json.Decode
import Json.Encode
import Json.Encode.Extra
import Dict exposing (Dict)


type alias Poll =
    { id : PollId
    , votes : Dict Name (List GameId)
    }


type alias PollId =
    String


type alias Name =
    String


encode : Poll -> Json.Encode.Value
encode poll =
    Json.Encode.object
        [ ( "id", Json.Encode.string poll.id )
        , ( "votes"
          , Json.Encode.Extra.dict
                identity
                (Json.Encode.list << List.map Json.Encode.string)
                poll.votes
          )
        ]


decoder : Json.Decode.Decoder Poll
decoder =
    Json.Decode.map2 Poll
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "votes" <| Json.Decode.dict <| Json.Decode.list Json.Decode.string)

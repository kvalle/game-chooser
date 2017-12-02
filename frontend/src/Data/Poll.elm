module Data.Poll exposing (Poll, PollId, encode, decoder)

import Data.Game exposing (GameId, Game)
import Json.Decode
import Json.Encode
import Json.Encode.Extra
import Dict exposing (Dict)


type alias Poll =
    { id : Maybe PollId
    , votes : Dict GameId (List Name)
    }


type alias PollId =
    String


type alias Name =
    String


encode : Poll -> Json.Encode.Value
encode poll =
    Json.Encode.object
        [ ( "id"
          , poll.id
                |> Maybe.map Json.Encode.string
                |> Maybe.withDefault Json.Encode.null
          )
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
        (Json.Decode.field "id" <| Json.Decode.maybe Json.Decode.string)
        (Json.Decode.field "votes" <| Json.Decode.dict <| Json.Decode.list Json.Decode.string)

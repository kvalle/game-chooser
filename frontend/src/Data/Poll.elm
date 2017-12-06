module Data.Poll exposing (Poll, PollId, decoder, setGame)

import Data.Game exposing (GameId, Game)
import Json.Decode
import Dict exposing (Dict)


type alias Poll =
    { id : PollId
    , games : Dict GameId Game
    , votes : Dict Name (List GameId)
    , voters : Dict GameId (List Name)
    }


type alias PollId =
    String


type alias Name =
    String


decoder : Json.Decode.Decoder Poll
decoder =
    Json.Decode.map4 Poll
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "games" <| Json.Decode.dict <| Data.Game.decoder)
        (Json.Decode.field "votes" <| Json.Decode.dict <| Json.Decode.list Json.Decode.string)
        (Json.Decode.field "voters" <| Json.Decode.dict <| Json.Decode.list Json.Decode.string)


setGame : (Game -> Game) -> GameId -> Poll -> Poll
setGame updateFn gameId poll =
    { poll
        | games = Dict.update gameId (Maybe.map updateFn) poll.games
    }

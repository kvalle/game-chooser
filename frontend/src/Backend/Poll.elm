module Backend.Poll exposing (create, getById, vote)

import Data.Poll exposing (Poll, PollId)
import Data.Game exposing (GameId)
import Task exposing (Task)
import Http exposing (Request, Error(..))
import Json.Decode
import Json.Encode
import Data.Environment exposing (Environment(..))
import Backend.Common
    exposing
        ( buildUrl
        , expectEmptyString
        , defaultConfig
        , send
        , post
        )


create : Environment -> List GameId -> Task Http.Error PollId
create env gameIds =
    post (buildUrl env [ "poll" ])
        (Http.jsonBody <|
            (Json.Encode.list << List.map Json.Encode.string) gameIds
        )
        (Http.expectJson <| Json.Decode.field "id" Json.Decode.string)


getById : Environment -> PollId -> Task Http.Error Poll
getById env pollId =
    post
        (buildUrl env [ "poll", pollId ])
        Http.emptyBody
        (Http.expectJson Data.Poll.decoder)


vote : Environment -> PollId -> List GameId -> Task Http.Error ()
vote env pollId gameIds =
    post
        (buildUrl env [ "poll", pollId, "vote" ])
        (Http.jsonBody <|
            (Json.Encode.list << List.map Json.Encode.string) gameIds
        )
        (expectEmptyString ())

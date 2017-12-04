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
        , post
        , get
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
    get
        (buildUrl env [ "poll", pollId ])
        (Http.expectJson Data.Poll.decoder)


vote : Environment -> PollId -> String -> List GameId -> Task Http.Error ()
vote env pollId name gameIds =
    post
        (buildUrl env [ "poll", pollId, "vote" ])
        (Http.jsonBody <|
            Json.Encode.object
                [ ( "name", Json.Encode.string name )
                , ( "game_ids", (Json.Encode.list << List.map Json.Encode.string) gameIds )
                ]
        )
        (expectEmptyString ())

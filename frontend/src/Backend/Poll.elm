module Backend.Poll exposing (create, getById, vote)

import Data.Poll exposing (Poll, PollId)
import Data.Game exposing (GameId)
import Task exposing (Task)
import Http exposing (Request, Error(..))
import Json.Decode
import Json.Encode
import Data.Environment exposing (Environment(..))
import Backend.Common exposing (buildUrl, request)
import Process
import Time


create : Environment -> List GameId -> Task Http.Error PollId
create env gameIds =
    case buildUrl env [ "poll" ] of
        Ok url ->
            Http.toTask <|
                request "POST"
                    url
                    (Http.jsonBody <|
                        (Json.Encode.list << List.map Json.Encode.string) gameIds
                    )
                    (Json.Decode.field "id" Json.Decode.string)

        Err err ->
            Task.fail <| Http.BadUrl err


getById : Environment -> PollId -> Task Http.Error Poll
getById env pollId =
    case buildUrl env [ "poll", pollId ] of
        Ok url ->
            Http.toTask <|
                request "GET" url Http.emptyBody Data.Poll.decoder

        Err err ->
            Task.fail <| Http.BadUrl err


vote : Environment -> PollId -> List GameId -> Task Http.Error ()
vote env pollId gameIds =
    Process.sleep (Time.second * 2)
        |> Task.andThen (always Task.succeed ())
        |> Task.mapError (always BadUrl "asdf")

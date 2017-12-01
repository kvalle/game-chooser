module Backend.Poll exposing (create)

import Data.Poll exposing (Poll, PollId)
import Task exposing (Task)
import Http exposing (Request)
import Json.Decode
import Data.Environment exposing (Environment(..))
import Backend.Common exposing (buildUrl, request)


create : Environment -> Poll -> Task Http.Error PollId
create env poll =
    case buildUrl env [ "poll" ] of
        Ok url ->
            request "GET" url Http.emptyBody (Json.Decode.field "id" Json.Decode.string)
                |> Http.toTask

        Err err ->
            Task.fail <| Http.BadUrl "err"

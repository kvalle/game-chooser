module Backend.Game exposing (getByName)

import Data.Game exposing (Game)
import Task exposing (Task)
import Http exposing (Request)
import Json.Decode
import Data.Environment exposing (Environment(..))
import Backend.Common exposing (buildUrl, request)


getByName : Environment -> String -> Task Http.Error (List Game)
getByName env username =
    case buildUrl env [ "user", username, "games" ] of
        Ok url ->
            request "GET" url Http.emptyBody (Json.Decode.list Data.Game.decoder)
                |> Http.toTask

        Err err ->
            Task.fail <| Http.BadUrl "err"

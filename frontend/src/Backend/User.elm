module Backend.User exposing (getByName)

import Data.User exposing (User)
import Task exposing (Task)
import Http exposing (Request)
import Json.Decode
import Data.Environment exposing (Environment(..))
import Backend.Common exposing (buildUrl, request)


getByName : Environment -> String -> Task Http.Error User
getByName env username =
    case buildUrl env [ "user", username ] of
        Ok url ->
            request "GET" url Http.emptyBody Data.User.decoder |> Http.toTask

        Err err ->
            Task.fail <| Http.BadUrl "err"

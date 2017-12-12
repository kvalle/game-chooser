module Backend.Game exposing (getByName)

import Data.Game exposing (Game)
import Task exposing (Task)
import Http
import Json.Decode
import Data.Environment exposing (Environment(..))
import Backend.Common exposing (buildUrl, get)


getByName : Environment -> String -> Task Http.Error (List Game)
getByName env username =
    get
        (buildUrl env [ "user", username, "games" ])
        (Http.expectJson <| Json.Decode.list Data.Game.decoder)

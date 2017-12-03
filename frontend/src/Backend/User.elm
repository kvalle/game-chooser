module Backend.User exposing (getByName)

import Data.User exposing (User)
import Task exposing (Task)
import Http exposing (Request)
import Data.Environment exposing (Environment(..))
import Backend.Common exposing (buildUrl, get)


getByName : Environment -> String -> Task Http.Error User
getByName env username =
    get
        (buildUrl env [ "user", username ])
        (Http.expectJson Data.User.decoder)

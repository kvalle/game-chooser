module Backend.User exposing (getByName)

import Data.User exposing (User)
import Task exposing (Task)
import Http exposing (Request)
import Json.Decode


getByName : String -> Task Http.Error User
getByName username =
    request "GET" (baseUrl ++ "user/" ++ username) Http.emptyBody Data.User.decoder
        |> Http.toTask


baseUrl : String
baseUrl =
    "http://localhost:7777/"


request : String -> String -> Http.Body -> Json.Decode.Decoder a -> Http.Request a
request method url body decoder =
    Http.request
        { method = method
        , headers = [ Http.header "Accept" "application/json" ]
        , url = url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }

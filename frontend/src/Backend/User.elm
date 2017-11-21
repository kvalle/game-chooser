module Backend.User exposing (getByName)

import Data.User exposing (User)
import Task exposing (Task)
import Http exposing (Request)
import Json.Decode
import Data.Environment exposing (Environment(..))


getByName : Environment -> String -> Task Http.Error User
getByName env username =
    case buildUrl env [ "user", username ] of
        Ok url ->
            request "GET" url Http.emptyBody Data.User.decoder |> Http.toTask

        Err err ->
            Task.fail <| Http.BadUrl "err"


buildUrl : Environment -> List String -> Result String String
buildUrl env fragments =
    case env of
        Localhost ->
            Ok <| "http://localhost:7777/" ++ (String.join "/" fragments)

        Unknown err ->
            Err ""


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

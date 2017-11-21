module Backend.Common exposing (buildUrl, request)

import Http exposing (Request)
import Json.Decode
import Data.Environment exposing (Environment(..))


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

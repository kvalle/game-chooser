module Backend.Common
    exposing
        ( buildUrl
        , expectEmptyString
        , defaultConfig
        , send
        , post
        , get
        )

import Http exposing (Request, Error)
import Data.Environment exposing (Environment(..))
import Task exposing (Task)
import Time exposing (Time)


type alias Config a =
    { method : String
    , headers : List Http.Header
    , url : String
    , body : Http.Body
    , expect : Http.Expect a
    , timeout : Maybe Time
    , withCredentials : Bool
    }


buildUrl : Environment -> List String -> Result String String
buildUrl env fragments =
    case env of
        Localhost ->
            Ok <| "http://localhost:7777/" ++ (String.join "/" fragments)

        Test ->
            Ok <| "https://test.api.game.kjetilvalle.com/" ++ (String.join "/" fragments)

        Prod ->
            Ok <| "https://api.game.kjetilvalle.com/" ++ (String.join "/" fragments)

        Unknown err ->
            Err ""


expectEmptyString : value -> Http.Expect value
expectEmptyString value =
    Http.expectStringResponse <|
        (\response ->
            case response.body of
                "" ->
                    Ok value

                _ ->
                    Err "Bad payload: Expected the empty string"
        )


defaultConfig : Config ()
defaultConfig =
    { method = "GET"
    , headers = [ Http.header "Accept" "application/json" ]
    , url = ""
    , body = Http.emptyBody
    , expect = expectEmptyString ()
    , timeout = Nothing
    , withCredentials = False
    }


send : Result String String -> Config a -> Task Http.Error a
send urlResult config =
    case urlResult of
        Ok url ->
            Http.toTask <| Http.request { config | url = url }

        Err err ->
            Task.fail <| Http.BadUrl err


post : Result String String -> Http.Body -> Http.Expect a -> Task Error a
post urlResult body responseExpectation =
    send urlResult
        { defaultConfig
            | method = "POST"
            , body = body
            , expect = responseExpectation
        }


get : Result String String -> Http.Expect a -> Task Error a
get urlResult responseExpectation =
    send urlResult
        { defaultConfig
            | method = "GET"
            , body = Http.emptyBody
            , expect = responseExpectation
        }

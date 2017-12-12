module Data.User exposing (User, UserId, encode, decoder)

import Json.Encode
import Json.Decode


type alias User =
    { id : UserId
    , username : String
    , firstname : String
    , lastname : String
    }


type alias UserId =
    String


encode : User -> Json.Encode.Value
encode user =
    Json.Encode.object
        [ ( "id", Json.Encode.string user.id )
        , ( "username", Json.Encode.string user.username )
        , ( "firstname", Json.Encode.string user.firstname )
        , ( "lastname", Json.Encode.string user.lastname )
        ]


decoder : Json.Decode.Decoder User
decoder =
    Json.Decode.map4 User
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "username" Json.Decode.string)
        (Json.Decode.field "firstname" Json.Decode.string)
        (Json.Decode.field "lastname" Json.Decode.string)

module Views.Helper.KeyCode
    exposing
        ( KeyCode
        , decoderFor
        , arrowDown
        , arrowUp
        , enter
        , questionMark
        , escape
        , tab
        , a
        )

import Json.Decode
import Json.Decode


type alias KeyCode =
    Int


decoderFor : KeyCode -> msg -> Json.Decode.Decoder msg
decoderFor keyCode msg =
    let
        checkKey actualCode =
            if actualCode == keyCode then
                Json.Decode.succeed msg
            else
                Json.Decode.fail "Wrong key"
    in
        Json.Decode.field "keyCode" Json.Decode.int
            |> Json.Decode.andThen checkKey


arrowDown : KeyCode
arrowDown =
    40


arrowUp : KeyCode
arrowUp =
    38


enter : KeyCode
enter =
    13


questionMark : KeyCode
questionMark =
    191


escape : KeyCode
escape =
    27


tab : KeyCode
tab =
    8


a : KeyCode
a =
    65

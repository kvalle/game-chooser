module Views.GameCard exposing (card, cards)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.Game exposing (Game, GameId)
import Material.Card as Card
import Material.Options as Options
import Material.Typography as Typography
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Toggles as Toggles
import Material.Icon as Icon
import Material


cards : (GameId -> Bool -> msg) -> (Material.Msg msg -> msg) -> Material.Model -> List Game -> List (Html msg)
cards setSelection mdlMsg mdlModel games =
    List.indexedMap
        (card setSelection mdlMsg mdlModel)
        games


card : (GameId -> Bool -> msg) -> (Material.Msg msg -> msg) -> Material.Model -> Int -> Game -> Html msg
card setSelection mdlMsg mdlModel index game =
    Card.view
        [ Options.cs "game-card"
        , Options.css "width" "200px"
        , Elevation.transition 250
        , if game.selected then
            Elevation.e4
          else
            Elevation.e0
        ]
        [ Card.title
            [ Options.css "height" "200px"
            , Options.css "padding" "0"
            , Options.css "position" "relative"
            , Options.onClick <| setSelection game.id (not game.selected)
            ]
            [ div
                [ class <|
                    if game.selected then
                        "game-card-image"
                    else
                        "game-card-image game-card-deselected"
                , style [ ( "background", "url('" ++ game.thumbnail_url ++ "') center / cover" ) ]
                ]
                []
            , Card.head
                [ Options.scrim 0.8
                , Options.css "padding" "16px"
                , Options.css "width" "100%"
                , Options.css "font-size" "1.3rem"
                , Color.text Color.white
                , Typography.title
                , Typography.contrast 1.0
                ]
                [ text game.title ]
            ]
        , Card.actions
            [ Card.border ]
            [ Toggles.checkbox mdlMsg
                [ index ]
                mdlModel
                [ Options.onClick <| setSelection game.id (not game.selected)
                , Toggles.ripple
                , Toggles.value game.selected
                , Options.cs "game-card-select-box"
                ]
                [ text "Selected" ]
            , a
                [ href <| "https://boardgamegeek.com/boardgame/" ++ game.id
                , target "_blank"
                ]
                [ Icon.view "info_outline"
                    [ Options.cs "game-card-info-link" ]
                ]
            ]
        ]

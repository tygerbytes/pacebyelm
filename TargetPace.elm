module TargetPace exposing (getTargetPaces, TargetPace, viewTargetPacePanel)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)


type alias TargetPace =
    { bestFiveKTime : String
    , runTypeName : String
    , targetPaceMi : String
    , targetPaceKm : String
    , targetSpeedMph : String
    , targetSpeedKph : String
    }


decodeTargetPace : Decoder TargetPace
decodeTargetPace =
    Decode.map6 TargetPace
        (field "best_five_k_time" Decode.string)
        (field "run_type" Decode.string)
        (field "target_pace_mi" Decode.string)
        (field "target_pace_km" Decode.string)
        (field "target_speed_mph" Decode.string)
        (field "target_speed_kph" Decode.string)


getTargetPaces : (Result Http.Error (List TargetPace) -> msg) -> String -> Cmd msg
getTargetPaces msg url =
    (Decode.list decodeTargetPace)
        |> Http.get url
        |> Http.send msg


getPaceDataClassList : String -> String -> Attribute msg
getPaceDataClassList fieldUnits selectedUnits =
    classList
        [ ( "pace_data_units_" ++ fieldUnits, True )
        , ( "hidden", (fieldUnits /= selectedUnits) )
        ]


viewTargetPacePanel : Maybe TargetPace -> String -> Html msg
viewTargetPacePanel targetPace units =
    let
        pace =
            case targetPace of
                Just targetPace ->
                    targetPace

                Nothing ->
                    TargetPace "" "" "" "" "" ""
    in
        div [ class "panel panel-info" ]
            [ div [ class "panel-heading" ]
                [ h2 [ class "panel-title" ]
                    [ text "Your mission, should you choose to accept it" ]
                ]
            , div [ class "panel-body", id "calculated_targets" ]
                [ div [ class "table-responsive" ]
                    [ table [ class "table table-striped table-hover" ]
                        [ thead []
                            [ tr []
                                [ th [ class "fit" ]
                                    []
                                , th []
                                    [ text "Your goal" ]
                                ]
                            ]
                        , tbody []
                            [ tr [ class "row-" ]
                                [ th [ class "fit", scope "row" ]
                                    [ text "5K race time" ]
                                , td []
                                    [ text pace.bestFiveKTime ]
                                ]
                            , tr []
                                [ th [ class "fit", scope "row" ]
                                    [ text "Run type" ]
                                , td []
                                    [ text pace.runTypeName ]
                                ]
                            , tr [ getPaceDataClassList "metric" units ]
                                [ th [ class "fit", scope "row" ]
                                    [ text "Pace (km)" ]
                                , td []
                                    [ text pace.targetPaceKm ]
                                ]
                            , tr [ getPaceDataClassList "imperial" units ]
                                [ th [ class "fit", scope "row" ]
                                    [ text "Pace (mi)" ]
                                , td []
                                    [ text pace.targetPaceMi ]
                                ]
                            , tr [ getPaceDataClassList "metric" units ]
                                [ th [ class "fit", scope "row" ]
                                    [ text "KPH" ]
                                , td []
                                    [ text pace.targetSpeedKph ]
                                ]
                            , tr [ getPaceDataClassList "imperial" units ]
                                [ th [ class "fit", scope "row" ]
                                    [ text "MPH" ]
                                , td []
                                    [ text pace.targetSpeedMph ]
                                ]
                            ]
                        ]
                    ]
                ]
            , div [ class "panel-footer", attribute "style" "padding-left: 2em; padding-right: 2em;" ]
                [ div [ class "row" ]
                    [ div [ class "pull-left", id "print_preview_button" ]
                        [ text "" ]
                    , div [ class "pull-right" ]
                        [ p [ class "text-muted", attribute "style" "padding-top: .5em;" ]
                            [ text "Donate: "
                            , a [ href "https://paypal.me/tygerbytes/5" ]
                                [ text "paypal.me/tygerbytes" ]
                            ]
                        ]
                    ]
                ]
            ]

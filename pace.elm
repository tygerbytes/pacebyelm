module Pacebyelm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode

-- MODEL

type alias Model =
    { fiveKTime : String
    }

initialModel : Model
initialModel =
    {
        fiveKTime = "25:00"
    }



-- UPDATE

type Msg = LoadRunnerStats

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadRunnerStats ->
            { model | fiveKTime = "25:00" } ! []



-- COMMANDS

loadRunnerStats : Cmd Msg
loadRunnerStats =
    Cmd.none


-- VIEW

viewHeader : Html Msg
viewHeader =
    div [ class "header clearfix" ]
      [ nav []
          [ ul [ class "nav nav-pills pull-right" ]
              [ li [ class "active", attribute "role" "presentation" ]
                  [ a [ href "#" ]
                      [ text "Home" ]
                  ]
              ]
          ]
      , h3 [ class "text-muted" ]
          [ text "🏃 Runby Pace, by "
          , a [ href "https://tygertec.com" ]
              [ text "tygertec" ]
          ]
      ]


viewJumbotron : Html Msg
viewJumbotron =
    div [ class "jumbotron" ]
      [ h1 []
          [ text "Training pace calculator, for "
          , em []
              [ text "you" ]
          ]
      , p [ class "lead" ]
          [ text "A good running program should incorporate runs at various paces and distances. But how fast should "
          , em []
              [ text "you" ]
          , text " be running for each pace, whether you're on the treadmill or gliding nimbly down the sylvan trail? Well say no more; welcome to the best personalized training pace calculator in the world! – Runby Pace."
          ]
      ]


viewToggleButtons : Html Msg
viewToggleButtons =
  div [ class "form-group" ]
      [ div [ class "btn-group btn-group-md", attribute "data-toggle" "buttons", id "fieldToggles" ]
          [ a [ class "btn btn-default active disabled" ]
              [ input [ type_ "checkbox" ]
                  []
              , span [ class "glyphicon glyphicon-heart-empty" ]
                  []
              , text "Default"
              ]
          , a [ class "btn btn-default" ]
              [ input [ id "toggle_units", name "units", type_ "checkbox" ]
                  []
              , span [ class "glyphicon glyphicon-wrench" ]
                   []
              , text "Units"
             ]
          ]
      ]



viewStatsForm : Html Msg
viewStatsForm =
      div [ id "calc_pace" ]
        [ Html.form [ attribute "accept-charset" "UTF-8", action "/target_pace/calc", attribute "data-remote" "true", method "post" ]
            [ input [ name "utf8", type_ "hidden", value "✓" ]
                []
            , text ""
            , input [ id "activated_toggles", name "activated_toggles", type_ "hidden", value "" ]
                []
            , div [ class "form-group" ]
                [ label [ for "five_k_time" ]
                    [ text "5K time:" ]
                , div [ class "input-group" ]
                    [ span [ class "input-group-addon" ]
                        [ span [ class "glyphicon glyphicon-heart-empty" ]
                            []
                        ]
                    , input [ class "form-control", id "five_k_time", name "five_k_time", placeholder "Your most recent 5K race time; example, 21:30", type_ "text", value "" ]
                        []
                    , text ""
                    ]
                ]
            , div [ class "form-group" ]
                [ label [ for "run_type" ]
                    [ text "Run type:" ]
                , div [ class "input-group" ]
                    [ span [ class "input-group-addon" ]
                        [ text "🏃" ]
                    , select [ class "form-control", id "run_type", name "run_type" ]
                        [ option [ value "DistanceRun" ]
                            [ text "Distance Run" ]
                        , option [ attribute "selected" "selected", value "EasyRun" ]
                            [ text "Easy Run" ]
                        , option [ value "FastTempoRun" ]
                            [ text "Fast Tempo Run" ]
                        , option [ value "LongRun" ]
                            [ text "Long Run" ]
                        , option [ value "SlowTempoRun" ]
                            [ text "Slow Tempo Run" ]
                        , option [ value "TempoRun" ]
                            [ text "Tempo Run" ]
                        ]
                    ]
                ]
            , div [ class "form-group hidden", id "form_field_units" ]
                [ label [ for "units" ]
                    [ text "Units:" ]
                , div [ class "input-group" ]
                    [ span [ class "input-group-addon" ]
                        [ text "📐" ]
                    , select [ class "form-control", id "units", name "units" ]
                        [ option [ value "metric" ]
                            [ text "Metric (Kilometers, Kilograms)" ]
                        , option [ attribute "selected" "selected", value "imperial" ]
                            [ text "Imperial (Miles, Pounds)" ]
                        ]
                    ]
                ]
            , div [ class "form-group" ]
                [ input [ class "btn btn-primary", attribute "data-disable-with" "Get your pace", name "commit", type_ "submit", value "Get your pace" ]
                    []
                , text ""
                ]
            , div [ attribute "style" "margin-bottom: 40px" ]
                []
            ]
        ]


viewFooter : Html Msg
viewFooter =
  footer [ class "footer" ]
    [ div [ class "container" ]
        [ hr []
            []
        , p [ class "text-muted" ]
            [ text "Runby Pace © 2017 Ty Walls "
            , a [ href "https://twitter.com/tygertec" ]
                [ text "@tygertec" ]
            ]
        ]
    ]


viewTargetPacePanel : Html Msg
viewTargetPacePanel =
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
                            []
                        ]
                    , tr []
                        [ th [ class "fit", scope "row" ]
                            [ text "Run type" ]
                        , td []
                            []
                        ]
                    , tr [ class "pace_data_units_metric hidden" ]
                        [ th [ class "fit", scope "row" ]
                            [ text "Pace (km)" ]
                        , td []
                            []
                        ]
                    , tr [ class "pace_data_units_imperial " ]
                        [ th [ class "fit", scope "row" ]
                            [ text "Pace (mi)" ]
                        , td []
                            []
                        ]
                    , tr [ class "pace_data_units_metric hidden" ]
                        [ th [ class "fit", scope "row" ]
                            [ text "KPH" ]
                        , td []
                            []
                        ]
                    , tr [ class "pace_data_units_imperial " ]
                        [ th [ class "fit", scope "row" ]
                            [ text "MPH" ]
                        , td []
                            []
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



view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewHeader
        , viewJumbotron
        , div [ class "row marketing" ]
            [ div [ class "col-md-6" ]
                [ h2 []
                    [ text "Your stats and targets" ]
                , viewToggleButtons
                , viewStatsForm
                ]
            , div [ class "col-md-6" ]
                [ viewTargetPacePanel ]
            ]
        , viewFooter
        ] 


main : Program Never Model Msg
main = Html.program
    { init = ( initialModel, loadRunnerStats )
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none )
    }

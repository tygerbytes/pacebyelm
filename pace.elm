module Pacebyelm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode

import TargetPace
import RunType



-- MODEL

type alias Model =
    { fiveKTime : String
    , toggles : List StatsToggle
    }


initialModel : Model
initialModel =
    {
      fiveKTime = "25:00"
    , toggles = initialToggles 
    }


type alias StatsToggle =
    { id : String
    , name : String
    , permanent : Bool
    , activated : Bool
    , glyphicon : String
    , text : String
    } 


initialToggles : List StatsToggle
initialToggles =
    [ StatsToggle "toggle_default" "default" True  True  "glyphicon-heart-empty" "Default"
    , StatsToggle "toggle_units"   "units"   False False "glyphicon-wrench"      "Units"
    ]



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


viewStatsToggle : StatsToggle -> Html Msg
viewStatsToggle toggle =
    a [ classList [ ("btn", True)
                  , ("btn-default", True)
                  , ("active", toggle.permanent || toggle.activated)
                  , ("disabled", toggle.permanent) ] 
      ]
        [ input [ type_ "checkbox" ]
            []
        , span [ class ("glyphicon " ++ toggle.glyphicon) ]
            []
        , text toggle.text
        ]


viewToggleButtons : List StatsToggle -> Html Msg
viewToggleButtons toggles =
    let
        toggleButtons =
            List.map (viewStatsToggle) toggles
    in
        div [ class "form-group" ]
            [ div [ class "btn-group btn-group-md", attribute "data-toggle" "buttons", id "fieldToggles" ]
              toggleButtons
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
            , RunType.viewRunTypes RunType.runTypes
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


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewHeader
        , viewJumbotron
        , div [ class "row marketing" ]
            [ div [ class "col-md-6" ]
                [ h2 []
                    [ text "Your stats and targets" ]
                , viewToggleButtons model.toggles
                , viewStatsForm
                ]
            , div [ class "col-md-6" ]
                [ TargetPace.viewTargetPacePanel ]
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

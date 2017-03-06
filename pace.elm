module Pacebyelm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode

-- MODEL

type alias Model =
    {
    }

initialModel : Model
initialModel =
    {
    }



-- UPDATE

type Msg = LoadRunnerStats

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadRunnerStats ->
            {} ! []



-- COMMANDS

loadRunnerStats : Cmd Msg
loadRunnerStats =
    Cmd.none


-- VIEW
view : Model -> Html Msg
view model =
    div [ class "container" ]
    [ text "hi" ]



main : Program Never Model Msg
main = Html.program
    { init = ( initialModel, loadRunnerStats )
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none )
    }

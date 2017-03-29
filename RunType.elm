module RunType exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias RunType =
    { name : String
    , description : String
    }


runTypes : List RunType
runTypes =
    [ RunType "DistanceRun" "Distance Run"
    , RunType "EasyRun" "Easy Run"
    , RunType "FastTempoRun" "Fast Tempo Run"
    , RunType "LongRun" "Long Run"
    , RunType "SlowTempoRun" "Slow Tempo Run"
    , RunType "TempoRun" "Tempo Run"
    ]


selectType : List RunType -> String -> RunType
selectType runTypes runType =
    let
        selection =
            runTypes
                |> List.filter (\t -> t.name == runType)
                |> List.head
    in
        case selection of
            Just runType ->
                -- Not sure why I have to reconstruct the RunType here...
                --  There's got to be a better approach to this entire function.
                RunType runType.name runType.description

            Nothing ->
                RunType "Unknown" "Unknown run type!"


viewRunTypeItem : RunType -> Html msg
viewRunTypeItem runType =
    option [ value runType.name ]
        [ text runType.description ]


viewRunTypes : List RunType -> Html msg
viewRunTypes runTypes =
    let
        types =
            List.map (viewRunTypeItem) runTypes
    in
        div [ class "form-group" ]
            [ label [ for "run_type" ]
                [ text "Run type:" ]
            , div [ class "input-group" ]
                [ span [ class "input-group-addon" ]
                    [ text "🏃" ]
                , select [ class "form-control", id "run_type", name "run_type" ]
                    types
                ]
            ]

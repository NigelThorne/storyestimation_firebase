module View exposing (root)

import Room.View
import Exts.Html.Bootstrap exposing (..)
import RemoteData exposing (..)
import Html exposing (..)
import Html as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ container
            [ h1 [] [ text "Vote-o-matic" ]
            , rootBody model
            ]
        ]


rootBody : Model -> Html Msg
rootBody model =
    case model.firebase of
        Success user ->
            case model.room of
                Nothing ->
                    text "Initialising."

                Just room ->
                    Room.View.root user room
                        |> Html.map RoomMsg

        Failure err ->
            div [ class "alert alert-danger" ] [ text err.message ]

        Loading ->
            h2 []
                [ i [] [ text "Checking your account." ]
                , loginButton
                ]

        NotAsked ->
            h2 []
                [ text "Log in to view and vote."
                , loginButton
                ]


loginButton : Html Msg
loginButton =
    button
        [ class "btn btn-primary pull-right"
        , onClick Authenticate
        ]
        [ text "Log In" ]

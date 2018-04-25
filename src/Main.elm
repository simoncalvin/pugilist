module Main exposing (main)

import Html exposing (Html, a, button, div, footer, form, h1, header, input, li, main_, p, section, text, ul)
import Html.Attributes exposing (class, href, id, maxlength, placeholder, type_)
import Html.Events exposing (onInput, onSubmit)
import Http exposing (get, send)
import Json.Decode exposing (list, string)


type alias Model =
    { search : String
    , results : List String
    }


main : Program Never Model Msg
main =
    Html.program
        { init = ( Model "" [], Cmd.none )
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


view : Model -> Html Msg
view model =
    div []
        [ header []
            [ h1 [] [ text "pugilist: your pull list" ] ]
        , main_ []
            [ p [ class "bold" ] [ text "Oh hi," ]
            , p [] [ text "Tell me a title on your list:" ]
            , form [ onSubmit SubmitSearch ]
                [ input [ onInput InputSearch, type_ "text", maxlength 100, placeholder "Title!" ]
                    [ text model.search ]
                , button [ type_ "submit" ] [ text "Submit" ]
                ]
            , section [ class "dreams" ]
                [ p [] [ text "Which one?" ]
                , ul [ id "results" ]
                    (model.results |> List.map (\dream -> li [] [ text dream ]))
                ]
            ]
        , footer []
            [ a [ href "https://glitch.com" ]
                [ text "Remix this in Glitch" ]
            ]
        ]


type Msg
    = InputSearch String
    | SubmitSearch
    | ReceiveSearch (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputSearch value ->
            ( { model | search = value }, Cmd.none )

        SubmitSearch ->
            ( model
            , Http.get ("/titles?search=" ++ model.search) (list string)
                |> Http.send ReceiveSearch
            )

        ReceiveSearch (Ok results) ->
            ( { model | results = results }, Cmd.none )

        ReceiveSearch (Err error) ->
            ( model, Cmd.none )

module Main exposing (main)

import Html exposing (Html, div, footer, h1, header, li, main_, p, section, text, ul)
import Html.Attributes exposing (class, id, type_)
import Http
import Request.Release as Releases exposing (Release)


type alias Model =
    { current : List Release
    , error : String
    }


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( Model [] ""
    , Releases.getCurrent
        |> Http.send Load
    )


view : Model -> Html Msg
view model =
    div []
        [ header []
            [ h1 [] [ text "pugilist: your pull list" ] ]
        , main_ []
            [ p [ class "bold" ] [ text "Oh hi," ]
            , p [] [ text "Here are the new comics for this week:" ]

            -- , form [ onSubmit SubmitSearch ]
            --     [ input [ onInput InputSearch, type_ "text", maxlength 100, placeholder "Title!" ]
            --         [ text model.search ]
            --     , button [ type_ "submit" ] [ text "Submit" ]
            --     ]
            , section [ class "dreams" ]
                [ -- p [] [ text "Which one?" ]
                  --,
                  ul [ id "results" ]
                    (model.current
                        |> List.map .title
                        |> List.map (\x -> li [] [ text x ])
                    )
                , p [] [ text model.error ]
                ]
            ]
        , footer []
            [--a [ href "https://glitch.com" ]
             --    [ text "Remix this in Glitch" ]
            ]
        ]


type Msg
    = Load (Result Http.Error (List Release))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load (Ok releases) ->
            ( { model | current = releases }, Cmd.none )

        Load (Err error) ->
            case error of
                Http.BadPayload message _ ->
                    ( { model | error = message }, Cmd.none )

                otherwise ->
                    ( model, Cmd.none )

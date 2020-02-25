module Main exposing (main)

import Browser
import Element exposing (Element)
import Html exposing (Html)


type Msg
    = DoNothing


type alias Model =
    ()


view : Model -> Html Msg
view _ =
    Element.layout [] (Element.paragraph [] [ Element.text "Basic Elm app" ])


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model


main : Program () Model Msg
main =
    Browser.sandbox
        { init = ()
        , view = view
        , update = update
        }

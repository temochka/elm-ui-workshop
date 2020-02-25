module Main exposing (main)

import Browser
import Element exposing (Element)
import Html exposing (Html)


type Msg
    = DoNothing


type alias Model =
    ()


layout : { sidebar : Element Msg, header : Element Msg, chat : Element Msg, editor : Element Msg } -> Element Msg
layout { sidebar, header, chat, editor } =
    Element.row [ Element.width Element.fill, Element.height Element.fill, Element.explain Debug.todo ]
        [ Element.el [ Element.width (Element.px 220), Element.height Element.fill, Element.explain Debug.todo ] sidebar
        , Element.column [ Element.width Element.fill, Element.height Element.fill, Element.explain Debug.todo ]
            [ Element.el [ Element.width Element.fill, Element.height (Element.px 70) ] header
            , Element.el [ Element.width Element.fill, Element.height Element.fill ] chat
            , Element.el [ Element.width Element.fill, Element.height (Element.px 70) ] editor
            ]
        ]


view : Model -> Html Msg
view _ =
    Element.layout [] (layout { sidebar = Element.none, header = Element.none, chat = Element.none, editor = Element.none })


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

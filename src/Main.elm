module Main exposing (main)

import Browser
import Element exposing (Element)
import Element.Background
import Element.Font
import Html exposing (Html)


type Msg
    = DoNothing


type alias Model =
    ()


sidebarBgColor : Element.Color
sidebarBgColor =
    Element.rgb255 48 7 49


sidebarFontColor : Element.Color
sidebarFontColor =
    Element.rgb255 195 179 195


layout : { sidebar : Element Msg, header : Element Msg, chat : Element Msg, editor : Element Msg } -> Element Msg
layout content =
    let
        sidebar =
            Element.el
                [ Element.width (Element.px 220)
                , Element.height Element.fill
                , Element.Background.color sidebarBgColor
                , Element.Font.color sidebarFontColor
                ]
                content.sidebar

        header =
            Element.el [ Element.width Element.fill, Element.height (Element.px 70) ] content.header

        chat =
            Element.el [ Element.width Element.fill, Element.height Element.fill ] content.chat

        editor =
            Element.el [ Element.width Element.fill, Element.height (Element.px 70) ] content.editor
    in
    Element.row [ Element.width Element.fill, Element.height Element.fill, Element.explain Debug.todo ]
        [ sidebar
        , Element.column [ Element.width Element.fill, Element.height Element.fill, Element.explain Debug.todo ]
            [ header
            , chat
            , editor
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

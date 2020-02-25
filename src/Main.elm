module Main exposing (main)

import Browser
import Element exposing (Element)
import Element.Background
import Element.Font
import Html exposing (Html)


type Msg
    = DoNothing


type UserStatus
    = Offline
    | Online


type alias User =
    { fullName : String
    , username : String
    , status : UserStatus
    }


type Conversation
    = Channel String
    | DirectMessage User


type alias Model =
    { conversations : List Conversation
    }


sidebarBgColor : Element.Color
sidebarBgColor =
    Element.rgb255 48 7 49


sidebarFontColor : Element.Color
sidebarFontColor =
    Element.rgb255 195 179 195


onlineGreen : Element.Color
onlineGreen =
    Element.rgb255 14 105 72


sidebarTitle : String -> Element Msg
sidebarTitle title =
    Element.el
        [ Element.Font.regular ]
        (Element.text title)


channelsList : List Conversation -> Element Msg
channelsList conversations =
    conversations
        |> List.map
            (\conversation ->
                case conversation of
                    Channel channel ->
                        Element.row [ Element.pointer ] [ Element.el [ Element.alpha 0.7 ] (Element.text "# "), Element.text channel ]

                    _ ->
                        Element.none
            )
        |> Element.column [ Element.spacing 5 ]


directMessagesList : List Conversation -> Element Msg
directMessagesList conversations =
    conversations
        |> List.map
            (\conversation ->
                case conversation of
                    DirectMessage user ->
                        let
                            statusIndicator =
                                case user.status of
                                    Online ->
                                        Element.el [ Element.Font.color onlineGreen ] (Element.text "●")

                                    Offline ->
                                        Element.text "○"
                        in
                        Element.row [ Element.pointer ] [ statusIndicator, Element.text " ", Element.text user.username ]

                    _ ->
                        Element.none
            )
        |> Element.column [ Element.spacing 5 ]


layout : { sidebar : Element Msg, header : Element Msg, chat : Element Msg, editor : Element Msg } -> Element Msg
layout content =
    let
        sidebar =
            Element.el
                [ Element.width (Element.px 220)
                , Element.height Element.fill
                , Element.Background.color sidebarBgColor
                , Element.Font.color sidebarFontColor
                , Element.Font.light
                , Element.padding 15
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
view { conversations } =
    layout
        { sidebar =
            Element.column
                [ Element.spacing 20 ]
                [ Element.column [ Element.spacing 10 ] [ sidebarTitle "Channels", channelsList conversations ]
                , Element.column [ Element.spacing 10 ] [ sidebarTitle "Direct Messages", directMessagesList conversations ]
                ]
        , header = Element.none
        , chat = Element.none
        , editor = Element.none
        }
        |> Element.layout []


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model


init : Model
init =
    { conversations =
        [ Channel "general"
        , Channel "random"
        , Channel "cats"
        , DirectMessage { fullName = "Leo Tolstoy", username = "leo", status = Online }
        , DirectMessage { fullName = "Frida Kalo", username = "frida", status = Offline }
        ]
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

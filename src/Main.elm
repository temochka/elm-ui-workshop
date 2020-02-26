module Main exposing (main)

import Browser
import Element exposing (Element)
import Element.Background
import Element.Border
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


type alias OpenConversation =
    { unreadCount : Int
    , mentionsCount : Int
    , kind : Conversation
    }


type alias Model =
    { openConversations : List OpenConversation
    }


sidebarBgColor : Element.Color
sidebarBgColor =
    Element.rgb255 48 7 49


sidebarFontColor : Element.Color
sidebarFontColor =
    Element.rgb255 195 179 195


sidebarImportantFontColor =
    Element.rgb255 255 255 255


onlineGreen : Element.Color
onlineGreen =
    Element.rgb255 14 105 72


notificationBadgeColor : Element.Color
notificationBadgeColor =
    Element.rgb255 191 11 66


notificationBadgeFontColor : Element.Color
notificationBadgeFontColor =
    Element.rgb255 255 255 255


sidebarTitle : String -> Element Msg
sidebarTitle title =
    Element.el
        [ Element.Font.regular ]
        (Element.text title)


notificationsBadge : List (Element.Attribute Msg) -> Int -> Element Msg
notificationsBadge attributes count =
    Element.el
        (attributes
            ++ [ Element.Background.color notificationBadgeColor
               , Element.Font.color notificationBadgeFontColor
               , Element.paddingXY 10 0
               , Element.Border.rounded 10
               ]
        )
        (Element.text (String.fromInt count))


channelsList : List OpenConversation -> Element Msg
channelsList conversations =
    conversations
        |> List.map
            (\conversation ->
                case conversation.kind of
                    Channel channel ->
                        let
                            fontProperties =
                                if conversation.unreadCount > 0 then
                                    [ Element.Font.regular, Element.Font.color sidebarImportantFontColor ]

                                else
                                    []

                            badge =
                                if conversation.mentionsCount > 0 then
                                    notificationsBadge [ Element.alignRight ] conversation.mentionsCount

                                else
                                    Element.none
                        in
                        Element.row
                            [ Element.pointer, Element.width Element.fill ]
                            [ Element.el [ Element.alpha 0.7 ] (Element.text "# ")
                            , Element.el fontProperties (Element.text channel)
                            , badge
                            ]

                    _ ->
                        Element.none
            )
        |> Element.column [ Element.spacing 5, Element.width Element.fill ]


directMessagesList : List OpenConversation -> Element Msg
directMessagesList conversations =
    conversations
        |> List.map
            (\conversation ->
                case conversation.kind of
                    DirectMessage user ->
                        let
                            statusIndicator =
                                case user.status of
                                    Online ->
                                        Element.el [ Element.Font.color onlineGreen ] (Element.text "●")

                                    Offline ->
                                        Element.text "○"

                            fontProperties =
                                if conversation.unreadCount > 0 then
                                    [ Element.Font.regular, Element.Font.color sidebarImportantFontColor ]

                                else
                                    []
                        in
                        Element.row [ Element.pointer ]
                            [ statusIndicator
                            , Element.text " "
                            , Element.el fontProperties (Element.text user.username)
                            ]

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
view { openConversations } =
    layout
        { sidebar =
            Element.column
                [ Element.spacing 20, Element.width Element.fill ]
                [ Element.column [ Element.spacing 10, Element.width Element.fill ] [ sidebarTitle "Channels", channelsList openConversations ]
                , Element.column [ Element.spacing 10, Element.width Element.fill ] [ sidebarTitle "Direct Messages", directMessagesList openConversations ]
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
    { openConversations =
        [ { kind = Channel "general", unreadCount = 20, mentionsCount = 1 }
        , { kind = Channel "random", unreadCount = 1, mentionsCount = 0 }
        , { kind = Channel "cats", unreadCount = 0, mentionsCount = 0 }
        , { kind = DirectMessage { fullName = "Leo Tolstoy", username = "leo", status = Online }, unreadCount = 3, mentionsCount = 0 }
        , { kind = DirectMessage { fullName = "Frida Kalo", username = "frida", status = Offline }, unreadCount = 0, mentionsCount = 0 }
        ]
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

module Main exposing (main)

import Browser
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Input
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


type alias Message =
    { text : String
    , reactions : List ( Char, Int )
    , author : User
    }


type alias Chat =
    { conversation : Conversation
    , participantsCount : Int
    , favorite : Bool
    , topic : Maybe String
    , messages : List Message
    }


type alias Model =
    { openConversations : List OpenConversation
    , chat : Chat
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


headerTextColor : Element.Color
headerTextColor =
    Element.rgb255 116 116 116


headerTitleColor : Element.Color
headerTitleColor =
    Element.rgb255 22 21 22


starColor : Element.Color
starColor =
    Element.rgb255 238 189 53


lightBorderColor : Element.Color
lightBorderColor =
    Element.rgb255 173 172 173


darkBorderColor : Element.Color
darkBorderColor =
    Element.rgb255 77 77 77


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
               , Element.Font.size 13
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


chatHeader : Chat -> Element Msg
chatHeader chat =
    let
        title =
            case chat.conversation of
                Channel name ->
                    "#" ++ name

                DirectMessage user ->
                    user.username

        favorite =
            (if chat.favorite then
                Element.el [ Element.Font.color starColor ] (Element.text "★")

             else
                Element.text "☆"
            )
                |> Element.el [ Element.pointer ]

        participants =
            case chat.conversation of
                Channel _ ->
                    Element.text ("👤" ++ String.fromInt chat.participantsCount)

                _ ->
                    Element.none

        topic =
            chat.topic
                |> Maybe.withDefault
                    (case chat.conversation of
                        Channel name ->
                            name

                        DirectMessage user ->
                            user.fullName
                    )
                |> Element.text

        meta =
            Element.column [ Element.width Element.fill, Element.spacing 5 ]
                [ Element.el [ Element.Font.semiBold, Element.Font.color headerTitleColor ] (Element.text title)
                , [ favorite, participants, topic ]
                    |> List.filter ((/=) Element.none)
                    |> List.intersperse (Element.el [ Element.paddingXY 5 0 ] (Element.text "|"))
                    |> Element.row [ Element.Font.color headerTextColor, Element.Font.size 12 ]
                ]

        search =
            Element.Input.search
                [ Element.width (Element.fill |> Element.minimum 170 |> Element.maximum 300)
                , Element.height (Element.px 35)
                , Element.Font.size 14
                , Element.Border.solid
                , Element.Border.width 1
                , Element.Border.rounded 3
                , Element.Border.color lightBorderColor
                ]
                { onChange = \_ -> DoNothing
                , text = ""
                , placeholder = Just (Element.Input.placeholder [] (Element.text "Search"))
                , label = Element.Input.labelHidden "Search"
                }
    in
    Element.row
        [ Element.width Element.fill
        ]
        [ meta
        , search
        ]


chatMessage : Message -> Element Msg
chatMessage message =
    let
        avatar =
            Element.el
                [ Element.width (Element.px 40), Element.height (Element.px 40), Element.Background.color (Element.rgb255 0 0 0) ]
                Element.none

        username =
            Element.el [ Element.Font.semiBold ] (Element.text message.author.username)

        timestamp =
            Element.el [ Element.Font.color headerTextColor, Element.Font.size 12 ] (Element.text "3:52pm")
    in
    Element.row [ Element.alignBottom, Element.width Element.fill, Element.spacing 5 ]
        [ avatar
        , Element.column
            [ Element.width Element.fill, Element.spacing 5 ]
            [ Element.paragraph [] [ username, Element.text " ", timestamp ]
            , Element.paragraph [ Element.width Element.fill, Element.Font.color (Element.rgb255 22 22 22) ] [ Element.text message.text ]
            ]
        ]


chatMessages : List Message -> Element Msg
chatMessages messages =
    messages
        |> List.map chatMessage
        |> Element.column [ Element.width Element.fill, Element.height Element.fill, Element.spacing 10 ]


messageEditor : Chat -> Element Msg
messageEditor chat =
    let
        conversationName =
            case chat.conversation of
                Channel name ->
                    "#" ++ name

                DirectMessage user ->
                    user.username

        placeholder =
            "Message " ++ conversationName
    in
    Element.Input.text
        [ Element.Border.color darkBorderColor
        , Element.width Element.fill
        ]
        { label = Element.Input.labelHidden placeholder
        , placeholder = Just (Element.Input.placeholder [] (Element.text placeholder))
        , onChange = \_ -> DoNothing
        , text = ""
        }


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
            Element.el [ Element.width Element.fill, Element.height (Element.px 70), Element.paddingXY 0 10 ] content.editor
    in
    Element.row [ Element.width Element.fill, Element.height Element.fill, Element.Font.size 15 ]
        [ sidebar
        , Element.column [ Element.width Element.fill, Element.height Element.fill, Element.padding 15 ]
            [ header
            , chat
            , editor
            ]
        ]


view : Model -> Html Msg
view { openConversations, chat } =
    layout
        { sidebar =
            Element.column
                [ Element.spacing 20, Element.width Element.fill ]
                [ Element.column [ Element.spacing 10, Element.width Element.fill ] [ sidebarTitle "Channels", channelsList openConversations ]
                , Element.column [ Element.spacing 10, Element.width Element.fill ] [ sidebarTitle "Direct Messages", directMessagesList openConversations ]
                ]
        , header = chatHeader chat
        , chat = chatMessages chat.messages
        , editor = messageEditor chat
        }
        |> Element.layout []


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model


init : Model
init =
    let
        leoTolstoy =
            { fullName = "Leo Tolstoy", username = "leo", status = Online }

        fridaKahlo =
            { fullName = "Frida Kalo", username = "frida", status = Offline }
    in
    { openConversations =
        [ { kind = Channel "general", unreadCount = 20, mentionsCount = 1 }
        , { kind = Channel "random", unreadCount = 1, mentionsCount = 0 }
        , { kind = Channel "cats", unreadCount = 0, mentionsCount = 0 }
        , { kind = DirectMessage leoTolstoy, unreadCount = 3, mentionsCount = 0 }
        , { kind = DirectMessage fridaKahlo, unreadCount = 0, mentionsCount = 0 }
        ]
    , chat =
        { conversation = Channel "cats"
        , participantsCount = 42
        , favorite = False
        , topic = Just "🐱 Post your favorite cat pictures! 🐱"
        , messages =
            [ { author = leoTolstoy
              , text = "Everyone thinks of changing the world, but no one thinks of changing himself."
              , reactions = [ ( '👍', 17 ) ]
              }
            , { author = leoTolstoy
              , text = "The sole meaning of life is to serve humanity."
              , reactions = []
              }
            , { author = leoTolstoy
              , text = "⬇️🎤⬇️"
              , reactions = [ ( '😂', 80 ) ]
              }
            , { author = fridaKahlo
              , text = "I hope the leaving is joyful; and I hope never to return."
              , reactions = [ ( '⬆', 3 ) ]
              }
            ]
        }
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

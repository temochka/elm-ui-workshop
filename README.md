# Elm UI workshop

This repo contains the example app that we’ll build during the workshop. It looks like this:

<img src="screenshots/app.png?raw=true" width="800" alt="The messenger app UI" title="Messenger">

All code is for reference purposes only. Use it if you get stuck during the workshop, but otherwise I encourage you to start with a fresh app!

## Instructions

1. [Download and Install Elm](https://guide.elm-lang.org/install/elm.html) (if you haven’t already).
2. [Download and Install Visual Studio Code](https://code.visualstudio.com)
3. [Install the Elm plugin for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode) (be careful not to download the other, deprecated plugin)
4. (Optional) In Visual Studio Code, press Cmd+Shift+P (Ctrl+Shift+P on Windows/Linux) and search for "Install 'code' command in PATH"
5. (Optional) [Install elm-format](https://github.com/avh4/elm-format#installation-) (requires NPM) for auto-formatting on save
6. Create a new directory, e.g. `mkdir elm-workshop; cd elm-workshop`
7. Initialize a new Elm project: `elm init`
8. Open the directory in Visual Studio Code: `code .`
9. Start the Elm Reactor: `elm reactor`
10. Create `src/Main.elm` and paste the following starter program, then go to [http://localhost:8000/src/Main.elm](http://localhost:8000/src/Main.elm) to check if everything works.

``` elm
module Main exposing (main)

import Browser
import Html exposing (Html)


type Msg
    = DoNothing


type alias Model =
    ()


view : Model -> Html Msg
view _ =
    Html.p [] [ Html.text "Basic Elm app" ]


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
```

import * as React from "/opt/Oni/resources/app/node_modules/react"
import * as Oni from "/opt/Oni/resources/app/node_modules/oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated")

    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"))

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}

export const configuration = {
    "autoClosingPairs.enabled": false,

    //"oni.useDefaultConfig": true,
    //"oni.bookmarks": ["~/Documents"],
    "oni.loadInitVim": true,
    "oni.hideMenu": true,

    // "editor.completions.mode": "hidden",
    "editor.cursorLine": false,
    "editor.fontSize": "15px",
    "editor.fontFamily": "Fira Code",

    // "ui.colorscheme": "nord",
    // "ui.colorscheme": "solarized8",
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",

    "tabs.mode": "buffers",
    "tabs.showIndex": true,

    // "sidebar.enabled": true,

    "experimental.markdownPreview.enabled": true,

    // "workspace.autoDetectWorkspace": "always"
}

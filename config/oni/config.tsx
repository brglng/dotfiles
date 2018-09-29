import * as React from "/opt/Oni/resources/app/node_modules/react"
import * as Oni from "/opt/Oni/resources/app/node_modules/oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated")

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")

    oni.input.bind("<f8>", "markdown.togglePreview")
}

export const configuration = {
    "achievements.enabled": false,
    "autoClosingPairs.enabled": true,

    //"oni.useDefaultConfig": true,
    //"oni.bookmarks": ["~/Documents"],
    "oni.loadInitVim": true,
    "oni.hideMenu": false,

    // "editor.completions.mode": "hidden",
    "editor.cursorLine": false,
    "editor.fontSize": "15px",
    "editor.fontFamily": "FuraCode Nerd Font Mono",
    "editor.maximizeScreenOnStart": true,

    // "language.cpp.languageServer.command": "clangd-6.0",
    // "language.cpp.languageServer.command": "cquery",
    // "language.cpp.languageServer.rootFiles": ["compile_commands.json", ".cquery"],
    // "language.cpp.languageServer.arguments": ["--init", '{"cacheDirectory": "~/.cache/cquery"}'],
    // "language.c.languageServer.command": "clangd-6.0",
    // "language.c.languageServer.command": "cquery",
    // "language.c.languageServer.rootFiles": ["compile_commands.json", ".cquery"],
    // "language.c.languageServer.arguments": ["--init", '{"cacheDirectory": "~/.cache/cquery"}'],

    "learning.enabled": false,

    // "ui.colorscheme": "nord",
    // "ui.colorscheme": "solarized8",
    // "ui.fontSmoothing": "auto",
    // "ui.animations.enabled": true,

    "tabs.mode": "buffers",
    "tabs.showIndex": true,

    // "workspace.autoDetectWorkspace": "always",

    "sidebar.default.open": false,

    "experimental.markdownPreview.enabled": true,
    "experimantal.indentLines.enabled": true,
}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}

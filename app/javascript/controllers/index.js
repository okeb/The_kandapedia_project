// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CommandPaletteController from "./command_palette_controller"
application.register("command-palette", CommandPaletteController)

import EditableController from "./editable_controller"
application.register("editable", EditableController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import SelectTagController from "./select_tag_controller"
application.register("select-tag", SelectTagController)

import TiptapController from "./tiptap_controller"
application.register("tiptap", TiptapController)

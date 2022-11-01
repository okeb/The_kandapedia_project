import { Controller } from "@hotwired/stimulus";
import debounce from "lodash.debounce";
import { Editor } from "@tiptap/core";

import { CodeBlockLowlight } from "@tiptap/extension-code-block-lowlight";
import Youtube from "@tiptap/extension-youtube";
import Code from '@tiptap/extension-code';
import Bold from "@tiptap/extension-bold";
import Blockquote from '@tiptap/extension-blockquote';
import Document from '@tiptap/extension-document';
import Italic from "@tiptap/extension-italic";
import Paragraph from '@tiptap/extension-paragraph';
import Text from '@tiptap/extension-text';
import Table from "@tiptap/extension-table";
import TableCell from "@tiptap/extension-table-cell";
import TableHeader from "@tiptap/extension-table-header";
import TableRow from "@tiptap/extension-table-row";
import TaskItem from "@tiptap/extension-task-item";
import TaskList from "@tiptap/extension-task-list";
import Strike from "@tiptap/extension-strike";
import Gapcursor from "@tiptap/extension-gapcursor";
import History from "@tiptap/extension-history";
import ListItem from '@tiptap/extension-list-item';
import BulletList from '@tiptap/extension-bullet-list';
import OrderedList from '@tiptap/extension-ordered-list';
import Heading from '@tiptap/extension-heading';
import HardBreak from '@tiptap/extension-hard-break';
import HorizontalRule from '@tiptap/extension-horizontal-rule';
import Dropcursor from "@tiptap/extension-dropcursor";
import Image from "@tiptap/extension-image";
import Underline from '@tiptap/extension-underline';
import Highlight from "@tiptap/extension-highlight";
import Link from "@tiptap/extension-link";
import Placeholder from "@tiptap/extension-placeholder";
import TextAlign from "@tiptap/extension-text-align";
// load all highlight.js languages
import { lowlight } from "lowlight";

// Connects to data-controller="tiptap"
export default class extends Controller {

  static targets = ["body", "input"]

  
  connect() {
    this.editor = new Editor({
      element: this.bodyTarget,
      extensions: [
        CodeBlockLowlight.configure({
          lowlight,
        }),
        BulletList,
        Blockquote,
        Link.configure({
          validate: (href) => /^https?:\/\//.test(href),
        }),
        Gapcursor,
        Paragraph,
        Highlight,
        Document,
        Text,
        Table.configure({
          resizable: true,
        }),
        TableRow,
        TableHeader,
        TableCell,
        Image,
        TaskList,
        TaskItem.configure({
          nested: true,
        }),
        Youtube.configure({
          controls: true,
          interfaceLanguage: "fr",
          enableIFrameApi: "true",
          nocookie: true,
        }),
        ListItem,
        History,
        Heading,
        HardBreak,
        HorizontalRule,
        OrderedList,
        Strike,
        Code,
        Bold,
        Italic,
        Dropcursor,
        Underline,
        TextAlign.configure({
          types: ["heading", "paragraph", "image", "list"],
        }),
        Placeholder.configure({
          placeholder: ({ node }) => {
            if (node.type.name === "heading") {
              return "Ecrivez un titre...";
            }

            return "Ecrivez quelque chose...";
          },
        }),
      ],
      onUpdate: debounce(this.onUpdate, 500),
      content: this.inputTarget.value,
    });
  }

  disconnect() {
    this.editor.destroy()
    console.log("hasta la vista tiptap");
  }

  onUpdate = () => {
    this.inputTarget.value = this.editor.getHTML();
    this.inputTarget.form.requestSubmit()
  };
}




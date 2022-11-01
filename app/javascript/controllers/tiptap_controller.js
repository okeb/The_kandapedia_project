import { Controller } from "@hotwired/stimulus";
import debounce from "lodash.debounce";
import { Editor } from "@tiptap/core";
// import StarterKit from "@tiptap/starter-kit";

import { CodeBlockLowlight } from "@tiptap/extension-code-block-lowlight";
import Code from '@tiptap/extension-code';
import Bold from "@tiptap/extension-bold";
import Blockquote from '@tiptap/extension-blockquote';
import Document from '@tiptap/extension-document';
import Italic from "@tiptap/extension-italic";
import Paragraph from '@tiptap/extension-paragraph';
import Text from '@tiptap/extension-text';
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
// import Image from "@tiptap/extension-image";
import Underline from '@tiptap/extension-underline';
import Highlight from "@tiptap/extension-highlight";
import Link from "@tiptap/extension-link";
import Placeholder from "@tiptap/extension-placeholder";
// load all highlight.js languages
import { lowlight } from "lowlight";


/*
BulletList,
ListItem,
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

image,


@tiptap/extension-bullet-list @tiptap/extension-list-item @tiptap/extension-heading @tiptap/extension-hard-break @tiptap/extension-horizontal-rule @tiptap/extension-ordered-list @tiptap/extension-code @tiptap/extension-bold @tiptap/extension-italic @tiptap/extension-dropcursor @tiptap/extension-underline
*/



// import { Color } from '@tiptap/extension-color';
// import { BubbleMenu } from '@tiptap/extension-bubble-menu';
// import CharacterCount from "@tiptap/extension-character-count";

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
        Link,
        Gapcursor,
        Paragraph,
        Highlight,
        Document,
        Text,
        // Image,
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
  onUpdate = () => {
    this.inputTarget.value = this.editor.getHTML();
    this.inputTarget.form.requestSubmit()
  };
}




import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

// Connects to data-controller="select-tag"
export default class extends Controller {
  static targets = ["select", "input"]
  connect() {
    let select_form = this.selectTarget.form;
    let input_form = this.inputTarget;
    new TomSelect(this.selectTarget, {
      plugins: ["remove_button", "caret_position"],
      placeholder: "Ecrivez vos tags...",
      create: true,
      onChange(){
        this.setTextboxValue("");
        this.refreshOptions();
        input_form.value = this.getValue().join(", ");
        select_form.requestSubmit();
      },
      persist: false,
      render: {
        option: function (data, escape) {
          return (
            '<div class="d-flex"><span>' +
            escape(data.value) +
            '</span><span class="ms-auto text-muted">' +
            escape(data.date) +
            "</span></div>"
          );
        },
        item: function (data, escape) {
          return "<div>" + escape(data.value) + "</div>";
        },
        loading: function (data, escape) {
          return '<div class="spinner"></div>';
        },
      },
    });
  }
}

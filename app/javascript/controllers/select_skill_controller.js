import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="select-tag"
export default class extends Controller {
  static targets = ["select", "input"];
  connect() {
    let input_form = this.inputTarget;
    new TomSelect(this.selectTarget, {
      plugins: ["remove_button", "caret_position"],
      placeholder: "Ecrivez vos expertises/compétences ici...",
      create: true,
      createFilter: function(input) {
        input = input.toLowerCase();
        return !((input in this.options || input == ""));
      },
      onChange() {
        this.setTextboxValue("");
        this.refreshOptions();
        input_form.value = this.getValue().join(", ");
      },
      persist: false,
      render: {
        option: function (data, escape) {
          return (
            '<div class="d-flex" style="justify-content:space-between; display:flex"><span>' +
            escape(data.value) +
            " fois utilisé</span></div>"
          );
        },
        item: function (data, escape) {
          return (
            "<div style='border-radius:5px'>" + escape(data.value) + "</div>"
          );
        },
        loading: function (data, escape) {
          return '<div class="spinner"></div>';
        },
        option_create: function(data, escape) {
          return '<div class="create">ajoutez <strong>' + escape(data.input) + '</strong>&hellip;</div>';
        },
        no_results:function(data,escape){
          return '<div class="no-results">Aucun résultats pour "'+escape(data.input)+'"</div>';
        }
      },
    });
  }
}

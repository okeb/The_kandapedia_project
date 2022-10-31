import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce";

// Connects to data-controller="editable"
export default class extends Controller {

  static targets = ["content", "input"]
  connect(){}
  changed = debounce(() => {
    this.inputTarget.value = this.contentTarget.innerHTML;
    this.inputTarget.form.requestSubmit();
  },700)
}

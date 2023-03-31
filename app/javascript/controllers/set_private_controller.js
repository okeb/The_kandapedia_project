import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="set-private"
export default class extends Controller {

  static targets = ["checkbox", "field", "text"]
  connect() {
  }

  switched () {
    if (this.fieldTarget.value == "0") {
      this.fieldTarget.value = "1"
      this.textTarget.innerHTML = "Private"
    } else {
      this.fieldTarget.value = "0";
      this.textTarget.innerHTML = "Public";
    }
    console.log(this.fieldTarget.value);
    this.fieldTarget.form.requestSubmit();
  }
}

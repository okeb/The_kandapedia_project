import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="editable"
export default class extends Controller {
  connect() {
    console.log("hello world", this.element);
  }
}

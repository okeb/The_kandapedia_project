import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "navbar__name_button"]
  connect() {
    console.log("Dropdown")
  }
  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle("hidden")
    this.navbar__name_buttonTarget.classList.toggle("active");
  }
  
  hide(event) {
    if (this.element.contains(event.target) === false) {
      this.menuTarget.classList.add("hidden");
      this.navbar__name_buttonTarget.classList.remove("active");
    }
  }
}

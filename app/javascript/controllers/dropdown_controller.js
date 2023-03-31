import Dropdown from "stimulus-dropdown";

// Connects to data-controller="dropdown"
export default class extends Dropdown {
  connect() {
    super.connect();
    console.log("Dropdown is ok.");
  }

  toggle(event) {
    super.toggle();
    console.log("Il toggle.");
  }

  hide(event) {
    super.hide(event);
    console.log("Il se hide.");
  }
}

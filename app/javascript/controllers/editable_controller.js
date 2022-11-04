import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce";
import slugify from "slugify";

// Connects to data-controller="editable"
export default class extends Controller {

  static targets = ["content", "input"]
  changed = debounce(() => {
    let uuid = this.contentTarget.getAttribute('data-uuid');
    let title = this.contentTarget.innerHTML;
    this.inputTarget.value = title;
    history.replaceState(
      {},
      "Kandapedia&trade; | " + title,
      "/questions/" + slugify(title, { lower: true,  strict: true, }) + "-" + uuid
    );
    this.inputTarget.form.requestSubmit();
  },1000)

}

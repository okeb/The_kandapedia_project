import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce";

/**
 * Slugify a string
 * @param {String} str trsint to slugify
 * @returns {String} string slugified
 */
function string_to_slug(str) {
  str = str.replace(/^\s+|\s+$/g, ""); // trim
  str = str.toLowerCase();

  var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
  var to = "aaaaeeeeiiiioooouuuunc------";
  for (var i = 0, l = from.length; i < l; i++) {
    str = str.replace(new RegExp(from.charAt(i), "g"), to.charAt(i));
  }

  str = str
    .toString()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .trim()
    .replace(/\s+/g, "-")
    .replace(/[^\w-]+/g, "")
    .replace(/--+/g, "-")
    .replace("nbsp-", "");

  if (str.slice(-1) === "-") {
    str = str.slice(0, -1) 
  }
  return str+'-';
}

// Connects to data-controller="editable"
export default class extends Controller {

  static targets = ["content", "input"]
  changed = debounce(() => {
    let uuid = this.contentTarget.getAttribute('data-uuid');
    let title = this.contentTarget.innerHTML.replace("  ", " ").trim();
    this.inputTarget.value = title;
    history.replaceState(
      {},
      "Kandapedia&trade; | " + title,
      "/questions/"+string_to_slug(title)+uuid
    );
    this.inputTarget.form.requestSubmit();
  },700)

}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sort-link"
export default class extends Controller {
  // These stimulus targets map to the targets defined in the DOM.
  // This will allow this controller to write to them directly
  static targets = ["sort", "direction"]
  connect() {
    console.log("sort_link_controller connected", this.element);
  }

  updateForm(event) {
    // Javascript function that extracts the search params from the passed in url

    let searchParams = new URL(event.detail.url).searchParams

    // 'this.sortTarget' translates to our field in the DOM
    this.sortTarget.value = searchParams.get("sort")
    this.directionTarget.value = searchParams.get("direction")
  }
}

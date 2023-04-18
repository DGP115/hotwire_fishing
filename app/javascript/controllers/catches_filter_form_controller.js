import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"

// Connects to data-controller="catches-filter-form"
export default class extends Controller {
  connect() {
    console.log("connected", this.element);
  }

  initialize() {
    this.submit = debounce(this.submit.bind(this), 300)
  }

  disconnect() {
    console.log("disconnected", this.element);
  }

  submit() {
    this.element.requestSubmit()
  }
}

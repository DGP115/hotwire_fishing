import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash-message-display"
/*
  1.  Set a timer to time how long this controller is in the DOM.  That timer starts
      in the connect() method.
      The js setTimout method takes a function as input and a time value in ms.
      It calls the given function when the time value has elapsed.
      The function we give it will remove the element [the flash message] that
      this controller is attached to, thus hiding the message.

  2.  Note also that we apply a css style [see custom.css] to fade the message in and out.
*/
export default class extends Controller {

  connect() {
    // 1.  Run the fade-in-and-out animation for the given time - 4s.
    console.log("connected", this.element);

    this.element.style.animation = "fade-in-and-out 4s"

    // 2.  Remove the flash message from the DOM after the given time.
    setTimeout(() => { this.remove() }, 4000)
  }

  remove() {
    this.element.remove()
  }
}

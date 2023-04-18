import { Controller } from "@hotwired/stimulus"

import noUiSlider from 'nouislider'
import wNumb from 'wnumb'

// Connects to data-controller="range-slider"
export default class extends Controller {
  static targets = ["slider", "currentMinWeight", "currentMaxWeight"]
  // stimulus "values" are js objects of type property value
  static values = { min: Number, max: Number }

  connect() {

    // Create a slider and put it at the "slider" target
    this.slider = noUiSlider.create(this.sliderTarget, {
      range: {
        min: this.minValue,
        max: this.maxValue
      },
      start: [this.currentMinWeightTarget.value, this.currentMaxWeightTarget.value],  // Start and
                                                                                      //end points
      step: 1,                                 // The increment per slider movement
      connect: [false, true, false],           //  See Note 1.
      tooltips: [wNumb({ decimals: 0}), wNumb({ decimals: 0})] // See Note 2.
      //Notes:
      /* 1. Controls the bar between the slider handles.
            Needs an array element for every connecting element.
            So two handles and the bar in between.

        2. One tooltip per handle, formatted as numbers
      */
    })

   /* To now write the min/max values of the slider back to the DOM:
    1.  Define stimulus targets in the DOM that map to @min_weight and @max_weight
    2.  The slider has a method called "on" that takes an event and a callback function as
        inputs.   When a slider handle is changed by the user, an "update" event is triggered.  Use that event to write the slider handle's value back to the DOM.

    3.  On "update", this slider returns:
          - handle:     0 for the min_handle and 1 for the max_handle
                        (to identify which handle was moved by the user to trigger the update   event)
          - values:     an array containing the value of the min handle and max handle in the
                        number format, since that is what we defined the stimulus values to be
                        e.g.:  ['7.00', '11.00']
          - unencoded:  same as 'values' but in raw format, so e.g. [7,11]

        So, based on the handle that triggred the update, set the appropriate Target

    4.  Wtih all the necessary variable values set, trigger the update of the fish catches list.
        Recall that is done [see index.html.erb] with "action:input->catches-filter-form#submit".
        So, trigger that event.  Use the bubbles="true" so the event is seen by listeners above us in the DOM
    */
    this.slider.on("update", (values, handle, unencoded) => {
      const target =
        (handle == 0) ? this.currentMinWeightTarget : this.currentMaxWeightTarget

      target.value = Math.round(unencoded[handle])

      target.dispatchEvent(new CustomEvent("input", { bubbles: true }))
    })
  }

  disconnect() {
    this.slider.destroy()
  }
}

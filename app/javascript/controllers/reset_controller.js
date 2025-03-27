import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset"
export default class extends Controller {
  connect() {
    console.log("reset connected")
  }
  
  reset() {
    this.element.reset()
  }


}


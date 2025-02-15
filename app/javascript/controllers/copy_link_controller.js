import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-link"
export default class extends Controller {
  static values = { url: String }

  connect() {
    console.log("Connected to copy-link controller!");
  }

  copy(event) {
    event.preventDefault();
    navigator.clipboard.writeText(this.urlValue)
      .then(() => {
        alert("✅ Tweet Link copied to clipboard!");

      })
      .catch(err => {
        console.error("Failed to copy text:", err);
      });
  }
}

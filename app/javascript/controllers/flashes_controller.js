import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Flash message connecté :", this.element);
    console.log("Flash message ajouté :", this.element);
    setTimeout(() => this.element.remove(), 3000); // Auto-disparition après 3s
  }
}

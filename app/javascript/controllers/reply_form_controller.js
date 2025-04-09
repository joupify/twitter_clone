import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "button"];

  connect() {
    // Ici on s'assure qu'on connecte correctement l'élément.
    console.log("Réponse de commentaire activée", this.element);
  }

  toggle(event) {
    event.preventDefault();

    // On cache tous les formulaires et boutons de réponses pour être sûr
    const allForms = document.querySelectorAll("[data-reply-form-target='form']");
    const allButtons = document.querySelectorAll("[data-reply-form-target='button']");

    // Masquer tous les formulaires et réafficher les boutons de réponse
    allForms.forEach((form) => {
      form.style.display = "none";
    });

    allButtons.forEach((btn) => {
      btn.style.display = "inline";
    });

    // Afficher uniquement le formulaire de ce commentaire en particulier
    const formToShow = this.formTarget;
    const buttonToHide = this.buttonTarget;

    formToShow.style.display = "block"; // Affiche le formulaire spécifique
    buttonToHide.style.display = "none"; // Cache le bouton de réponse

    
  }
}

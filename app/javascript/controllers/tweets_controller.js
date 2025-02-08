import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  connect() {
    console.log("Stimulus Controller connecté :", this.element);

    this.subscription = consumer.subscriptions.create("TweetsChannel", {
      received: (data) => {
        console.log("Nouveau tweet reçu :", data);

        // Sélectionne l'élément cible manuellement si `this.element` est undefined
        const target = this.element || document.querySelector("#tweets-container");

        if (target) {
          target.insertAdjacentHTML("beforeend", data);
        } else {
          console.error("Erreur : L'élément cible pour les tweets est introuvable !");
        }
      }
    });
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
      console.log("Désabonnement du canal TweetsChannel.");
    }
  }
}

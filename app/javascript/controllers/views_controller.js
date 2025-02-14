import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.incrementViews();
  }

  incrementViews() {
    const tweetId = this.element.dataset.id;

    if (!tweetId) return; // Vérifie qu'il y a bien un ID

    fetch(`/tweets/${tweetId}/increment_views`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Content-Type": "application/json"
      }
    });
  }
}

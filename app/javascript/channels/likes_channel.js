import consumer from "./consumer"

consumer.subscriptions.create("LikesChannel", {
  connected() {
    console.log("Connected to LikesChannel");
  },

  disconnected() {
    console.log("Disconnected from LikesChannel");
  },

  received(data) {
    console.log("Received data:", data);
    // Ajoutez ici le code pour mettre à jour l'interface utilisateur
  }
});
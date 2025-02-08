import consumer from "./consumer"

consumer.subscriptions.create("TweetsChannel", {
  connected() {
    console.log("Connected to TweetsChannel");
  },

  disconnected() {
    console.log("Disconnected from TweetsChannel");
  },

  received(data) {
    console.log("Received data:", data);
    // Ajoutez ici le code pour mettre à jour l'interface utilisateur
  }
});
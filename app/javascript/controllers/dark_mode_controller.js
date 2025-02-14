import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Dark mode controller connected!");

    this.loadDarkMode();
  }

  toggle() {
    document.body.classList.toggle("dark-mode");
    const darkModeEnabled = document.body.classList.contains("dark-mode");
    document.cookie = `dark_mode=${darkModeEnabled}; path=/;`;
  }

  loadDarkMode() {
    if (document.cookie.split("; ").find((row) => row.startsWith("dark_mode=true"))) {
      document.body.classList.add("dark-mode");
    }
  }
}

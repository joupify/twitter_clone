// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)


// Afficher les contrôleurs chargés
console.log("🚀 Stimulus controllers enregistrés :", application.controllers);

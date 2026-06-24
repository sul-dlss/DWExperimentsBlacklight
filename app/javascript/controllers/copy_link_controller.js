import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-link"
export default class extends Controller {
  static values = {
    url: String,
    message: String,
    error: String
  }

  async copyLink() {
    try {
      await navigator.clipboard.writeText(this.urlValue)

      this.showToast("bi-check-circle-fill", this.messageValue)
    } catch (err) {
      console.error("Failed to copy text: ", err)

      this.showToast("bi-exclamation-circle-fill", this.errorValue)
    }
  }

  showToast(iconClass, message) {
    const html = `<i class="bi ${iconClass} pe-1" aria-hidden="true"></i> ${message}`
    window.dispatchEvent(new CustomEvent("show-toast", { detail: { html } }))
  }
}

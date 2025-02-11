import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = { tweetId: Number }
  static targets = ["likeButton", "unlikeButton", "likesCount"]

  connect() {
    console.log("Likes controller connected!")
    console.log("likeButtonTarget:", this.likeButtonTarget)
    console.log("unlikeButtonTarget:", this.unlikeButtonTarget)
    console.log("likesCountTarget:", this.likesCountTarget)

    this.subscription = consumer.subscriptions.create(
      { channel: "LikesChannel" },
      {
        received: (data) => {
          if (data.tweet_id === this.tweetIdValue) {
            this.updateLikes(data)
          }
        }
      }
    )
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  updateLikes(data) {
    console.log("Data received:", data)
  
    if (this.hasLikesCountTarget) {
      this.likesCountTarget.textContent = `${data.likes_count} likes`
    }
  
    if (this.hasLikeButtonTarget && this.hasUnlikeButtonTarget) {
      if (data.user_liked) {
        console.log("User liked, updating DOM")
        this.likeButtonTarget.classList.add("d-none")
        this.unlikeButtonTarget.classList.remove("d-none")
      } else {
        console.log("User unliked, updating DOM")
        this.unlikeButtonTarget.classList.add("d-none")
        this.likeButtonTarget.classList.remove("d-none")
      }
    } else {
      console.error("Like or Unlike button not found in updateLikes!")
    }
  }
  
  like(event) {
    event.preventDefault()
    fetch(this.likeButtonTarget.form.action, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
  }

  unlike(event) {
    event.preventDefault()
    fetch(this.unlikeButtonTarget.form.action, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
  }
}
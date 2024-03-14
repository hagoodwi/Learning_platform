import { Controller } from "@hotwired/stimulus"
import { cable } from "@hotwired/turbo-rails"

export default class extends Controller {
  connect() {
    this.subscribe()
    this.scrollMessages()
  }

  subscribe() {
    const turboCableStreamTag = document.querySelector("turbo-cable-stream-source")
    const signedStreamName = turboCableStreamTag.channel.signed_stream_name
    const channelName = turboCableStreamTag.channel.channel

    const scrollMessages = this.scrollMessages.bind(this)

    this.channel = cable.subscribeTo({ channel: channelName, signed_stream_name: signedStreamName }, {
      received(data) {
        setTimeout(scrollMessages, 100)

        // const messagesContainer = document.getElementById("messages")
        // if (messagesContainer) {
        //   // Предполагаем, что 'data' содержит HTML вашего сообщения
          
        //   messagesContainer.insertAdjacentHTML('beforeend', data)
        // }

        // const currentUserId = document.body.getAttribute('data-current-user-id');
        // const messages = document.querySelectorAll('.message');

        // messages.forEach((message) => {
        //   console.log(data)
        //   const messageUserId = message.getAttribute('data-user-id');
        //   if (messageUserId === currentUserId) {
        //     message.classList.add('out');
        //     // console.log("out")
        //   } else {
        //     message.classList.add('in');
        //     // console.log("in")
        //     // console.log("userID", currentUserId)
        //     // console.log("messageUserId", messageUserId)
        //   }
        // });
      }
    })
  }

  clearInput() {
    this.element.reset()
  }

  scrollMessages() {
    const chatContainer = document.getElementById("chat-container")
    console.log(chatContainer)
    if (chatContainer) chatContainer.scrollTop = chatContainer.scrollHeight
  }
}
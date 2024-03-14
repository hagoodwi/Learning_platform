class MessagesController < ApplicationController
    def create
        @new_message = current_user.messages.build(message_params)

        if @new_message.save
            @new_message.broadcast_append_to @new_message.chat, locals: { user: current_user }
        end
    end

    private
        def message_params
            params.require(:message).permit(:content, :chat_id)
        end
end

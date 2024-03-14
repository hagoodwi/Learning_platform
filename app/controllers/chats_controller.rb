class ChatsController < ApplicationController
    before_action :authorization_check
    
    # def index
    #     @chats = current_user.chats
    #     # @chat = current_user.chat
    # end

    def index
        # @chats = Chat.all.includes(:messages).map do |chat|
        @chats = current_user.chats.includes(:messages).map do |chat|
            last_message = chat.messages.order(created_at: :desc).last
            sender = last_message&.user
            sender_name = sender.short_name if sender
            time_diff = last_message ? time_ago_in_words(last_message.created_at) : ""
        
            { chat: chat, last_message: last_message, sender_name: sender_name, time_diff: time_diff }
        end
    end

    def new
        @chat = Chat.new
        @users = User.all
    end

    def create
        # @chat = current_user.chats.new()
        @chat = Chat.new(chat_params)
        @chat.user_id = current_user.id
        if @chat.save
            @chat.users << current_user
            params[:user_ids].each do |user_id|
                @chat.users << User.find(user_id)
              end
            redirect_to chats_path(@chat)
        else
            debugger
            redirect_to request.referer
        end
    end

    def show
        @chat = Chat.find_by!(id: params[:id])
        @messages = @chat.messages
        @new_message = current_user.messages.build
    end

    def destroy
        @chat = Chat.find_by!(id: params[:id])
        @chat.destroy
        redirect_to chats_path
    end

    private
        def chat_params
            params.require(:chat).permit(:name, :user_id, :user_ids)
        end

        def time_ago_in_words(time)
            seconds = Time.current - time
            case seconds
            when 0..59 then "недавно"
            when 60..3599 then "#{(seconds / 60).to_i} минут назад"
            when 3600..86399 then "#{(seconds / 3600).to_i} часов назад"
            else "#{(seconds / 1.day).to_i} дней назад"
            end
        end

        def authorization_check
            redirect_to new_user_session_path, alert: 'Требуется авторизация' unless user_signed_in?
        end
end

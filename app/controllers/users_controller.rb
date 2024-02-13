class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @user_roles = @user.roles
    end

    def search_users
        query = params[:query]
        @users = User.full_text_search(params[:query])
        respond_to do |format|
          format.html { render partial: 'users/add_users_list', locals: { users: @users } }
        end
    end

    def search_users_list
        query = params[:query]
        @users = User.full_text_search(params[:query])
        respond_to do |format|
          format.html { render partial: 'users/users_list', locals: { users: @users } }
        end
    end

    private

        def group_params
            params.require(:user).permit(:name, :description, :user_ids)
        end
end

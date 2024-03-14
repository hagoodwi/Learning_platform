class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @user_roles = @user.roles
    end

    # TODO: сделать возможность редактирования, блокирования, удаления профиля

    # Используется из js чтоб осуществлять поиск пользователей на странице добавления
    # (возвращается список пользователей с кнопкой добавить)
    def search_users
        query = params[:query]
        @users = User.full_text_search(params[:query])
        respond_to do |format|
          format.html { render partial: 'users/add_users_list', locals: { users: @users } }
        end
    end

    # Используется из js чтоб осуществлять поиск пользователей на странице администрирования
    # (возвращается просто список пользователей без кнопки добавить)
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

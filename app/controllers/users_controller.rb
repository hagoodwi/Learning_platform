class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @user_roles = @user.roles
    end

    private

        def group_params
            params.require(:user).permit(:name, :description, :user_ids)
        end
end

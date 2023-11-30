class Admin::RolesController < AdminController
    def index
        @roles = Role.all
    end

    def show
        @role = Role.find(params[:id])
        # @users_with_role = RoleUser.joins(:role).where(roles: { name: @role.name })
        @users_with_role = @role.users
    end

    def new
        @role = Role.new
        @users = User.all
    end

    def create
        @role = Role.new(role_params)
        if @role.save
            if params[:role][:user_ids].present?
                @role.user_ids = params[:role][:user_ids]
            end
            redirect_to admin_role_path(@role), notice: "Роль создана"
        else
            render 'new', notice: "Произошла ошибка"
        end
    end

    def destroy
        @role = Role.find(params[:id])
        @role.destroy
        redirect_to admin_roles_path, notice: "Роль была удалена"
    end

    private

        def role_params
            params.require(:role).permit(:name, :user_ids)
        end
end

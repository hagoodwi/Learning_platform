class Admin::RolesController < AdminController
    def index
        @roles = Role.all
    end

    def show
        @role = Role.find(params[:id])
        @users_with_role = @role.users
    end

    def new
        @role = Role.new
        @users = User.all
    end

    def create
        @role = Role.new(role_params)
        Role.transaction do
          if @role.save
            @role.user_ids = params[:role][:user_ids] if params[:role][:user_ids].present?
            redirect_to admin_role_path(@role), notice: "Роль создана"
          else
            render 'new', status: :unprocessable_entity
          end
        end
    rescue ActiveRecord::RecordInvalid
      render 'new', status: :unprocessable_entity
    end

    # TODO: реализовать функционал для редактирования ролей

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

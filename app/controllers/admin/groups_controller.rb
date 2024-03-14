class Admin::GroupsController < AdminController
    def index
        @groups = Group.page(params[:page]).per(5)
    end

    def show
        @group = Group.find_by!(id: params[:id])
        @users_in_group = @group.users.page(params[:page]).per(5)
    end

    def new
        @group = Group.new
        @users = User.all
    end

    def create
        @group = Group.new(group_params)
        Group.transaction do
            if @group.save
              @group.user_ids = params[:user_ids].reject(&:blank?) if params[:user_ids].present?
              redirect_to admin_group_path(@group), notice: 'Группа успешно создана.'
            else
              render :new, status: :unprocessable_entity
            end
        end
    rescue ActiveRecord::RecordInvalid
        render :new, status: :unprocessable_entity
    end

    def edit
        @group = Group.find(params[:id])
        @users = User.all
    end


    # TODO: Переделать обновление списка пользователей в группе (сделать как при создании)
    def update
        @group = Group.find(params[:id])
        Group.transaction do
            if @group.update(group_params)
              @group.user_ids = Array.wrap(params[:group][:user_ids])
              redirect_to admin_group_path(@group), notice: 'Группа успешно обновлена.'
            else
              render 'edit', status: :unprocessable_entity
            end
        end
    rescue ActiveRecord::RecordInvalid
      render 'edit', status: :unprocessable_entity
    end

    def destroy
        @group = Group.find(params[:id])
        @group.destroy
        redirect_to admin_groups_path, notice: "Группа была удалена"
    end

    private
        def group_params
            params.require(:group).permit(:name, :description, :user_ids)
        end
end

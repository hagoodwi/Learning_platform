class Admin::GroupsController < AdminController
    def index
        @groups = Group.all
    end

    def show
        @group = Group.find_by!(id: params[:id])
        @users_in_group = @group.users
    end

    def new
        @group = Group.new
        @users = User.all
    end

    def create
        @group = Group.new(group_params) 
        if @group.save
            if params[:group][:user_ids].present?
                # @users_to_add = User.where(id: params[:group][:user_ids])
                # @group.users << @users_to_add if @users_to_add.present?
                @group.user_ids = params[:group][:user_ids]
            end
            redirect_to admin_group_path(@group)
        else
            render 'new'
        end
    end

    def edit
        @group = Group.find(params[:id])
        @users = User.all
    end

    def update
        @group = Group.find(params[:id])
        if @group.update(group_params)
            @group.user_ids = params[:group][:user_ids]
            flash[:notice] = "Группа обновлена"
            redirect_to admin_group_path(@group)
        else
            render 'edit'
        end
    end

    def destroy
        @group = Group.find(params[:id])
        @group.destroy
        redirect_to admin_groups_path, notice: "Группа была удалена"
    end

    # def update_users
    #     @group = Group.find(params[:id])
    
    #     # Обновляем список принадлежащих группе пользователей
    #     @group.user_ids = params[:group][:user_ids]

    #     flash[:notice] = "Группа успешно обновлена"
    #     # Перенаправляем пользователя после сохранения изменений
    #     redirect_to @group
    # end

    # def add_user
    #     # debugger
    #     @group = Group.find(params[:id])
    #     @user = User.find(params[:user][:id])
    #     @group.users << @user
    
        
    #     redirect_to group_path(@group)
    # end

    # def add_users
    #     @group = Group.find(params[:id])
    #     @userss = User.where.not(id: @group.user_ids)

    #     # debugger
    
    #     if params[:group][:user_ids].present?
    #       @users_to_add = User.where(id: params[:group][:user_ids])
    #       @group.users << @users_to_add if @users_to_add.present?
    #     end
    
    #     redirect_to group_path(@group)
    # end

    # def del_user
    #     @group = Group.find(params[:id])
    #     @user = User.find()
    # end

    private

        def group_params
            params.require(:group).permit(:name, :description, :user_ids)
        end
    # debugger
end

class Admin::UsersController < AdminController
    def index
      @users = User.all
    end

    # Выводится вся инфа по пользователю в разделе админа
    def show
      @user = User.find(params[:id])
      @user_roles = @user.roles
      @user_groups = @user.groups
      @courses_where_teacher = Course.joins(role_users: :role).where(role_users: { user_id: params[:id] }, roles: { name: 'teacher' })
      @courses_where_student = Course.joins(role_users: :role).where(role_users: { user_id: params[:id] }, roles: { name: 'student' }).where('courses.start_date <= ? AND courses.end_date >= ?', Date.today, Date.today)
    end

    # Реализовать мезанизм редактирования профиля администратором
    def edit
      # @user = User.find(params[:id])
      # @user_roles = @user.roles
      # @user_groups = @user.groups
      # @courses_where_teacher = Course.joins(role_users: :role).where(role_users: { user_id: params[:id] }, roles: { name: 'teacher' })
      # @courses_where_student = Course.joins(role_users: :role).where(role_users: { user_id: params[:id] }, roles: { name: 'student' })
      # debugger
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Пользователь успешно обновлен'
      else
        render 'edit'
      end
    end
end

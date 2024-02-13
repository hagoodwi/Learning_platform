class Moderator::CoursesController < ModeratorController
    # Проверка на то, что пользователь либо админ, либо модератор этого курса
    before_action :check_access_to_discipline, 
            only: [:show, :edit, :update, :destroy, :edit_teachers, :update_teachers, :edit_students, :update_students, :edit_disciplines, :update_disciplines]

    def index
        # Если админ, то получаем все курсы 
        if current_user.has_role?('admin')
            @courses = Course.page(params[:page]).per(5)
        # Иначе получаем только те, на которых являемся модератором
        else
            @courses = Course.joins(role_users: :role)
                                .where(role_users: { user_id: current_user.id, roles: { name: 'moderator' } })
                                .page(params[:page]).per(5)
        end
    end

    # На странице курсы выводим преподавателей, дисциплины, студентов
    # TODO: переделать поиск преподавателей, так как они добавляются не на сам курс, а на дисциплину_на_курсе
    #       к самому курсу привязаны только студенты и модераторы 
    def show
        @disciplines = @course.disciplines
        @teachers = RoleUser.joins(:role, :courses).where(roles: { name: 'teacher'}, courses: { id: params[:id] })
        @students = RoleUser.joins(:role, :courses).where(roles: { name: 'student'}, courses: { id: params[:id] })
    end

    def new
        @course = Course.new
    end

    # Создание курса (без добавления пользователей)
    def create
        @course = Course.new(course_params)

        if !(@course.start_date.present? && @course.end_date.present? && @course.start_date <= @course.end_date)
            redirect_to request.referer, alert: "Неверно указаны сроки проведения"
            return
        end
        Course.transaction do
            if @course.save
              # Привязываем текущего пользователя к курсу в роли модератора, если это возможно
              moderator = current_user.get_role_user('moderator')
              @course.role_users << moderator if moderator
      
              redirect_to moderator_course_path(@course), notice: "Курс создан"
            else
              # Если курс не сохраняется из-за других ошибок валидации
              render 'new', status: :unprocessable_entity
            end
        end
    rescue ActiveRecord::RecordInvalid
        # В случае возникновения исключения в транзакции
        redirect_to request.referer, alert: "Произошла ошибка"
    end


    def edit
    end

    def update
        if @course.update(course_params)
            redirect_to moderator_course_path(@course)
        else
            redirect_to request.referer
        end
    end

    def edit_teachers
        @teacher_role_users = RoleUser.joins(:role).where(roles: { name: 'teacher' })
    end

    # Добавление преподавателей на курс
    # TODO: нужно переделать, потому что преподы добавляются не на сам курс, а на дисциплину_на_курсе
    #       поэтому нужно сделать добавление на конкретную дисицплину
    def update_teachers
        other_users = RoleUser.joins(:role, :courses).where.
            not(roles: { name: 'teacher'}).where( courses: { id: params[:id] }).ids

        merged_ids = other_users
        if params[:course] && params[:course][:teacher_role_users].present?
            merged_ids = other_users | params[:course][:teacher_role_users].map(&:to_i)
        end

        @course.role_user_ids = merged_ids
        redirect_to moderator_course_path(@course)
    end

    def edit_students
        @student_role_users = RoleUser.joins(:role).where(roles: { name: 'student' })
    end

    # TODO: добавление сделать также, как добавление в группу
    # TODO: накинуть транзакцию
    def update_students
        # Получаем ID пользователей с ролями, отличными от 'student', связанных с курсом
        other_users = RoleUser.joins(:role, :courses).where.
            not(roles: { name: 'student'}).where( courses: { id: params[:id] }).ids
        
        merged_ids = other_users

        # Собираем ID студентов из параметров, если они предоставлены
        if params[:course] && params[:course][:student_role_users].present?
            # Объединяем ID студентов и нестудентов
            merged_ids = other_users | params[:course][:student_role_users].map(&:to_i)
        end

        @course.role_user_ids = merged_ids
        redirect_to moderator_course_path(@course)
    end

    def edit_disciplines
        @disciplines = Discipline.all
    end

    def update_disciplines
        params[:course][:discipline_ids].each do |discipline_id|
            discipline = Discipline.find(discipline_id)
            @course.course_disciplines.find_or_create_by(discipline: discipline)
        end
        redirect_to moderator_course_path(@course)
    end

    def destroy
        @course.destroy
        redirect_to moderator_courses_path
    end

    # TODO: реализовать возможность управление списком модераторов курса

    private
        def check_access_to_discipline
            @course = Course.find(params[:id])
            redirect_to root_path, alert: 'Доступ запрещен' unless @course.role_users.exists?(user_id: current_user.id, role_id: Role.find_by(name: 'moderator')&.id) || @is_admin
        end

        def course_params
            params.require(:course).permit(:name, :start_date, :end_date, :description, :teacher_role_users, :student_role_users, :discipline_ids)
        end
end

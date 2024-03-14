class Moderator::CoursesController < ModeratorController
    before_action :check_access_to_discipline, 
            only: [:show, :edit, :update, :destroy, :edit_teachers, :update_teachers, :edit_students, :update_students, :edit_disciplines, :update_disciplines]

    def index
        if current_user.has_role?('admin')
            @courses = Course.all
        else
            @courses = Course.joins(role_users: :role).where(role_users: { user_id: current_user.id, roles: { name: 'moderator' } })
        end
    end

    def show
        @disciplines = @course.disciplines
        @teachers = RoleUser.joins(:role, :courses).where(roles: { name: 'teacher'}, courses: { id: params[:id] })
        @students = RoleUser.joins(:role, :courses).where(roles: { name: 'student'}, courses: { id: params[:id] })
        @course = Course.find(params[:id])
        @schedules = Schedule.joins(course_disciplines: :discipline).where(course_disciplines: { course_id: @course.id })
        selected_date = params[:selected_date]&.to_date || Date.current
        @schedules_by_day = generate_schedules_by_day(selected_date)
        # Здесь еще всяких преподов, участников, материалы и прочее
    end

    def new
        @course = Course.new
    end

    def create
        @course = Course.new(course_params)
        if @course.start_date.nil? || @course.end_date.nil? || @course.start_date > @course.end_date
            redirect_to request.referer, alert: "Неверны указаны сроки проведения"
            return
        end
        if @course.save
            moderator = current_user.get_role_user('moderator')
            if !moderator.nil?
                @course.role_users << moderator
            end
            redirect_to moderator_course_path(@course), notice: "Курс создан"
        else
            redirect_to request.referer, alert: "Произошла ошибка"
        end
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

    def update_students
        # Можно оптимизировать
        other_users = RoleUser.joins(:role, :courses).where.
            not(roles: { name: 'student'}).where( courses: { id: params[:id] }).ids
        
        merged_ids = other_users
        if params[:course] && params[:course][:student_role_users].present?
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
    

    private
        def generate_schedules_by_day(selected_date)
            start_date = selected_date.beginning_of_month
            end_date = selected_date.end_of_month
            (start_date..end_date).map do |date|
            schedules = Schedule.joins("INNER JOIN course_disciplines ON course_disciplines.id=schedules.course_discipline_id
            INNER JOIN disciplines ON disciplines.id=course_disciplines.discipline_id")
                .where(course_disciplines: { course_id: @course.id })
                .where('DATE(schedules.start_time) = ?', date)
            puts schedules.inspect
            { date: date, schedules: schedules }
            end
        end
        def check_access_to_discipline
            @course = Course.find(params[:id])
            redirect_to root_path, alert: 'Доступ запрещен' unless @course.role_users.exists?(user_id: current_user.id, role_id: Role.find_by(name: 'moderator')&.id) || @is_admin
        end

        def course_params
            params.require(:course).permit(:name, :start_date, :end_date, :description, :teacher_role_users, :student_role_users, :discipline_ids)
        end
end



# def new
    #     @course = Course.new
    #     @teacher_role_user = RoleUser.joins(:role).where(roles: { name: 'teacher' })
    #     @student_role_user = RoleUser.joins(:role).where(roles: { name: 'student' })
    #     # @teacher_user =  User.joins(:roles).where(roles: { name: 'teacher' })
    #     # @student_user =  User.joins(:roles).where(roles: { name: 'student' })
    #     # Здесь еще всяких преподов, участников, материалы и прочее
    # end

    # def create
    #     @course = Course.new(course_params)
    #     if @course.start_date.nil? || @course.end_date.nil? || @course.start_date > @course.end_date
    #         @teacher_role_user = RoleUser.joins(:role).where(roles: { name: 'teacher' })
    #         @student_role_user = RoleUser.joins(:role).where(roles: { name: 'student' })
    #         render 'new', notice: "Произошла ошибка"
    #         return
    #     end
        
    #     if @course.save
    #         if params[:course][:teacher_role_user].present?
    #             @course.role_user_ids = params[:course][:teacher_role_user]
    #         end
    #         if params[:course][:student_role_user].present?
    #             @course.role_user_ids = params[:course][:student_role_user]
    #         end
    #         redirect_to @course, notice: "Курс создан"
    #     else
    #         render 'new', notice: "Произошла ошибка"
    #     end
    # end
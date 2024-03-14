class CoursesController < ApplicationController
    def index
        @courses = Course.all
    end

    def show
        @course = Course.find(params[:id])
        @disciplines = @course.disciplines
        @teachers = RoleUser.joins(:role, :courses).where(roles: { name: 'teacher'}, courses: { id: params[:id] })
        @students = RoleUser.joins(:role, :courses).where(roles: { name: 'student'}, courses: { id: params[:id] })
        @schedules = Schedule.joins(course_disciplines: :discipline).where(course_disciplines: { course_id: @course.id })
        selected_date = params[:selected_date]&.to_date || Date.current
        @schedules_by_day = generate_schedules_by_day(selected_date)
        # Здесь еще всяких преподов, участников, материалы и прочее
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
        def course_params
            params.require(:course).permit(:name, :start_date, :end_date, :description, :teacher_role_users, :student_role_users)
        end
end

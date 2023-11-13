class CoursesController < ApplicationController
    def index
        @courses = Course.all
    end

    def show
        @course = Course.find(params[:id])
        # Здесь еще всяких преподов, участников, материалы и прочее
    end

    def new
        @course = Course.new
        # Здесь еще всяких преподов, участников, материалы и прочее
    end

    def create
        @course = Course.new(course_params)
        if @course.start_date.nil? || @course.end_date.nil? || @course.start_date > @course.end_date
            flash[:notice] = "Произошла ошибка"
            render 'new', notice: "Произошла ошибка"
            return
        end
        
        if @course.save
            flash[:notice] = "Курс создан"
            redirect_to @course
        else
            flash[:notice] = "Произошла ошибка"
            render 'new'
        end
    end

    def edit
        @course = Course.find(params[:id])
    end

    def update
        @course = Course.find(params[:id])
        if @course.update(course_params)
          redirect_to @course
        else
          render 'edit'
        end
    end

    def destroy
        @course = Course.find(params[:id])
        @course.destroy
        redirect_to courses_path
    end
    

    private
        def course_params
            params.require(:course).permit(:name, :start_date, :end_date, :description)
        end
end

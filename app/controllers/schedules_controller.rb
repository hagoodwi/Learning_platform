class SchedulesController < ApplicationController
 def new
   @schedule = Schedule.new
   @courses = Course.all
 end
 def create
  start_times_hash = params[:schedule][:start_times]
  start_times = start_times_hash.values
  end_times_hash = params[:schedule][:end_times]
  end_times = end_times_hash.values
  course_discipline = CourseDiscipline.find_by(course_id: params[:schedule][:course_id], discipline_id: params[:schedule][:discipline_id])
  course_discipline_id = course_discipline&.id
  params[:schedule] = params[:schedule].merge(course_discipline_id: course_discipline_id)
  start_times.each_with_index do |start_time, index|
    @schedule = Schedule.new(
      course_discipline_id: params[:schedule][:course_discipline_id],
      start_time: start_time,
      end_time: end_times[index]
    )
    unless unique_schedule?
      redirect_to request.referer, alert: "Запись об этом занятии уже создана" and return
    end
    @schedule.save
  end
  redirect_to request.referer, notice: 'Новые записи в расписании созданы'
end

def carousel
  @course = Course.find(params[:id])
  selected_date = "#{params[:selected_date]}-01"&.to_date || Date.current
  @schedules_by_day = generate_schedules_by_day(selected_date)
  respond_to do |format|
    format.html { render partial: 'carousel' }
  end
end

 def load_disciplines
   course_id = params[:course_id]
   if course_id
     course = Course.find(course_id)
     @disciplines = course.disciplines
   else
     @disciplines = []
   end
   respond_to do |format|
     format.json { render json: @disciplines }
   end
 end
#не используется
 def show
  @course = Course.find(params[:id])
  @schedules = Schedule.joins(course_disciplines: :discipline).where(course_disciplines: { course_id: @course.id })
  selected_date = params[:selected_date]&.to_date || Date.current
  @schedules_by_day = generate_schedules_by_day(selected_date)
 end
#пока не используется
 def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    redirect_to request.referer, notice: "Запись удалена"
 end


 private
#пока не используется
 def schedule_params
  course_discipline = CourseDiscipline.find_by(course_id: params[:schedule][:course_id], discipline_id: params[:schedule][:discipline_id])
  course_discipline_id = course_discipline&.id
  params.require(:schedule).permit(start_times: [], end_times: []).merge(course_discipline_id: course_discipline_id)
 end

 def unique_schedule?
  Schedule.where(
    course_discipline_id: @schedule.course_discipline_id,
    start_time: @schedule.start_time,
    end_time: @schedule.end_time
  ).none?
  end

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

#пока не используется
  def overlapping_time?(schedule1, schedule2)
    schedule1_start_time = schedule1.start_time
    schedule1_end_time = schedule1.end_time
    schedule2_start_time = schedule2.start_time
    schedule2_end_time = schedule2.end_time
  
    (schedule1_start_time..schedule1_end_time).overlaps?(schedule2_start_time..schedule2_end_time)
  end
end

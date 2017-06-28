class App::Dashboards::OnlineLectureHistoriesController < App::DashboardsController
  def index
    @online_lecture_histories = OnlineLectureHistory
                                  .includes(online_lecture: :teacher, details: :online_lecture_list)
                                  .where(match_id: params[:dashboard_id]).original_only.between(@start_date, @end_date)
  end

  def new
    @online_lecture_history = OnlineLectureHistory.new(match_id: params[:dashboard_id])
  end

  def create
    @online_lecture_history = OnlineLectureHistory.new(online_lecture_history_params)
    @online_lecture_history.create_histories(online_lecture_history_params)
    return if @online_lecture_history.save
    render :new
  end

  def edit
    @online_lecture_history = OnlineLectureHistory.includes(online_lecture: :teacher, details: :online_lecture_list).find_by(id: params[:id], match_id: params[:dashboard_id])
  end

  def update
    @online_lecture_history = OnlineLectureHistory.find(params[:id])
    @online_lecture_history_detail = OnlineLectureHistory.find(params[:detail_id])
    if @online_lecture_history_detail.update(online_lecture_update_params)
      @online_lecture_history.reload
    else
      render :edit
    end
  end

  def list
    if !online_lecture_history_params[:online_provider_id].blank?
      @online_teachers = Standard::OnlineTeacher.where(online_provider_id: online_lecture_history_params[:online_provider_id])
    elsif !online_lecture_history_params[:online_teacher_id].blank?
      @online_lectures = Standard::OnlineLecture.where(online_teacher_id: online_lecture_history_params[:online_teacher_id])
    end
  end

  private

  def online_lecture_history_params
    params
      .fetch(:online_lecture_history, {})
      .permit(:match_id,
              :online_provider_id, :online_teacher_id, :online_lecture_id,
              :started_at, :planned_at)
  end

  def online_lecture_update_params
    params
      .permit(:planned_at, :completed_at)
  end
end

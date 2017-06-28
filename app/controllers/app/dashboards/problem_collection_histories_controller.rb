class App::Dashboards::ProblemCollectionHistoriesController < App::DashboardsController
  def index
    @problem_collection_histories = ProblemCollectionHistory
                                      .includes(:problem_collection)
                                      .where(match_id: params[:dashboard_id]).until(@start_date, @end_date)
  end

  def show
    @problem_collection_history = ProblemCollectionHistory.includes(problem_collection: :problems, problem_histories: :problem).find_by(id: params[:id], match_id: params[:dashboard_id])
    return if @problem_collection_history.score?
    @problem_collection_history.build_problems
    render :edit
  end

  def update
    @problem_collection_history = ProblemCollectionHistory.includes(problem_collection: :problems).find(params[:id])
    return if @problem_collection_history.update(problem_collection_history_params)
    render :edit
  end

  private

  def problem_collection_history_params
    params
      .fetch(:problem_collection_history, {})
      .permit(problem_histories_attributes: [:users_answer, :match_id, :subject_id, :problem_collection_id, :problem_id])
  end
end

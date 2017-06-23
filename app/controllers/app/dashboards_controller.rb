class App::DashboardsController < ApplicationController
  before_action :set_date_params

  def index
    if current_user.mentor?
      @matches = Match.includes(:mentor, :mentor_users, :mentee, :mentee_users, :schedules).where(mentor_id: current_user.mentor.id)
    elsif current_user.mentee?
      @matches = Match.includes(:mentor, :mentor_users, :mentee, :mentee_users, :schedules).where(mentee_id: current_user.mentee.id)
    end

    if @matches.blank? # 본인의 대쉬보드가 없을 경우 리다이렉트
      redirect_to root_path
    elsif @matches.size == 1 # 본인의 대쉬보드가 1개만 있을 경우 리다이렉트
      redirect_to dashboard_path(@matches.first)
    end
  end

  def show
    respond_to do |format|
      format.html do
        @match = Match.includes(:mentor, :mentor_users, :mentee, :mentee_users, :schedules).find(params[:id])
        # 본인의 대쉬보드가 아닐 경우 리다이렉트
        return if (current_user.mentor? && @match.mentor_id == current_user.mentor.id) || (current_user.mentee? && @match.mentee_id == current_user.mentee.id)
        redirect_to dashboards_path
      end
      format.js
    end
  end

  private

  def set_date_params
    @start_date =
      if params[:start_date].nil? || params[:start_date].blank?
        Time.zone.now.beginning_of_week
      else
        Time.zone.local(params[:start_date].split('-')[0].to_i, params[:start_date].split('-')[1].to_i, params[:start_date].split('-')[2].to_i, 0, 0, 0)
      end
    @end_date =
      if params[:end_date].nil? || params[:end_date].blank?
        Time.zone.now.end_of_week
      else
        Time.zone.local(params[:end_date].split('-')[0].to_i, params[:end_date].split('-')[1].to_i, params[:end_date].split('-')[2].to_i, 23, 59, 59)
      end
    @end_date = @start_date.end_of_week if @start_date > @end_date
  end
end

class AchievementsController < ApplicationController
  before_action :load_all_teams, except: :index
  before_action :load_achievement, only: :destroy
  load_and_authorize_resource

  def index
    @achievements = Achievement.latest.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def new; end

  def create
    if @achievement.save
      flash[:success] = t ".flash_created_achievement"
      redirect_to achievements_path
    else
      flash[:danger] = t ".flash_create_failed"
      render :new
    end
  end

  def destroy
    if @achievement.destroy
      flash[:success] = t "flash_deleted_achievement"
    else
      flash[:danger] = t "flash_delete_failed"
    end
    redirect_to achievements_path
  end

  private

  def achievement_params
    params.require(:achievement).permit :name, :received_day, :team_id, :picture
  end

  def load_all_teams
    @team_list = Team.alphabet.map{|t| [t.name, t.id]}
  end

  def load_achievement
    @achievement = achievement.find_by id: params[:id]
    return if @achievement
    flash[:danger] = t ".flash_achievement_not_found"
    redirect_to root_path
  end
end

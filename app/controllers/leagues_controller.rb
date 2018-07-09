class LeaguesController < ApplicationController
  before_action :load_league, only: %i(show edit update destroy)
  before_action :load_team_list, only: %i(new edit)
  load_and_authorize_resource

  def index
    @leagues = League.all.paginate page: params[:page], per_page: Settings.per_page
  end

  def show; end

  def new; end

  def edit; end

  def update
    if @league.update_attributes league_params
      load_team_to_league @league, params[:add_teams]
      remove_team_from_league @league, params[:remove_teams]
      flash[:success] = t ".flash_updated_league"
      redirect_to @league
    else
      flash[:danger] = t ".flash_update_failed"
      render :edit
    end
  end

  def create
    load_team_to_league @league, params[:add_teams]
    if @league.save
      flash[:success] = t ".league_create_success"
      redirect_to @league
    else
      render :new
    end
  end

  def destroy
    if @league.destroy
      clear_league_team(@league) if @league.teams.present?
      flash[:success] = t ".flash_deleted_league"
    else
      flash[:danger] = t ".flash_delete_failed"
    end
    redirect_to leagues_path
  end

  private

  def load_league
    @league = League.find_by id: params[:id]
    return if @league
    flash[:danger] = t ".not_found_league"
    redirect_to leagues_path
  end

  def load_team_list
    @team_not_in_league = Team.not_include(@league.teams).map{|t| [t.name, t.id]}
    @team_in_league = @league.teams.map{|t| [t.name, t.id]}
  end

  def load_team_to_league league, team_ids
    Team.load_team_from_ids(team_ids).each do |team|
      league.teams << team if league.teams.exclude? team
    end
  end

  def remove_team_from_league league, team_ids
    Team.load_team_from_ids(team_ids).each do |team|
      league.teams.delete(team) if league.teams.include? team
    end
  end

  def clear_league_team league
    league.teams.clear
  end

  def league_params
    params.require(:league).permit :name, :logo
  end
end

class TeamsController < ApplicationController
  before_action :load_team, except: %i(index new create remove_player)
  before_action :admin_user, except: %i(show index)
  before_action :load_remove_player, :load_current_team, only: :remove_player
  before_action :load_teams_continents_countries_collections, only: :index

  def index
    load_countries_by_continent if params[:continent_id]
    load_searched_result if params[:search]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show; end

  def edit; end

  def update
    if @team.update_attributes team_params
      flash[:success] = t ".flash_updated_team"
      redirect_to @team
    else
      flash[:danger] = t ".flash_update_failed"
      render :edit
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new team_params
    if @team.save
      flash[:success] = t ".flash_created_team"
      redirect_to @team
    else
      flash[:danger] = t ".flash_create_failed"
      render :new
    end
  end

  def destroy
    remove_all_team_players if @team.players.present?
    if @team.destroy
      flash[:success] = t ".flash_deleted_team"
    else
      flash[:danger] = t ".flash_delete_failed"
    end
    redirect_to teams_path
  end

  def manage_team_players
    @team_players = @team.players
  end

  def remove_player
    @player.team_id = nil
    if @player.save
      flash[:success] = t ".flash_removed_player"
    else
      flash[:danger] = t ".flash_remove_failed"
    end
    redirect_to manage_team_players_path @current_team
  end

  private

  def team_params
    params.require(:team).permit :name, :stadium, :picture, :city, :coach,
      :president, :description, :logo
  end

  def load_team
    @team = Team.find_by id: params[:id]
    return if @team
    flash[:danger] = t ".flash_team_not_found"
    redirect_to root_path
  end

  def load_remove_player
    @player = Player.find_by id: params[:id]
    return if @player
    flash[:danger] = t "flash_player_not_found"
    redirect_to root_path
  end

  def load_current_team
    @current_team = Team.find_by id: @player.team_id
    return if @current_team
    flash[:danger] = t "flash_team_not_found"
    redirect_to root_path
  end

  def remove_all_team_players
    list_team_players = Player.owned_by(@team.id).pluck :id
    Player.load_player_from_ids(list_team_players).update_all(team_id: nil)
  end

  def load_teams_continents_countries_collections
    @teams = Team.alphabet.paginate page: params[:page], per_page: Settings.per_page
    @continent_list = Continent.alphabet.pluck :name, :id
    @country_list = Country.alphabet.pluck :name, :id
  end

  def load_searched_result
    @teams = @teams.owner_country(params[:country_id]) if params[:country_id]
    @teams = @teams.search_by_name(params[:search]) if params[:search]
    @teams = @teams.paginate page: params[:page], per_page: Settings.per_page
  end

  def load_countries_by_continent
    @country_list = Country.owner_continent(params[:continent_id]).pluck :name, :id
  end
end

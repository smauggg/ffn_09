class PlayersController < ApplicationController
  before_action :load_all_teams, only: %i(new create)
  before_action :load_player, only: :destroy
  load_and_authorize_resource

  def index
    @players = Player.alphabet.paginate page: params[:page], per_page: Settings.per_page
  end

  def new; end

  def create
    if @player.save
      flash[:success] = t ".flash_created_player"
      redirect_to players_path
    else
      flash[:danger] = t ".flash_create_failed"
      render :new
    end
  end

  def destroy
    if @player.destroy
      flash[:success] = t "flash_deleted_player"
    else
      flash[:danger] = t "flash_delete_failed"
    end
    redirect_to admin_players_path
  end

  private

  def player_params
    params.require(:player).permit :name, :dob, :position, :p_number, :picture, :team_id
  end

  def load_player
    @player = Player.find_by id: params[:id]
    return if @player
    flash[:danger] = t ".flash_player_not_found"
    redirect_to root_path
  end

  def load_all_teams
    @team_list = Team.alphabet.map{|t| [t.name, t.id]}
  end
end

class MatchesController < ApplicationController
  before_action :load_match, only: %i(show destroy)
  before_action :load_all_filter, only: %i(index load_league_matches)
  before_action :load_all_matches, :load_filtered_result, only: :index
  before_action :load_league, :load_league_teams, only: :new
  load_and_authorize_resource

  def show
    store_location
    return unless logged_in?
    @bet = user_bet current_user, @match
    @bet ||= @match.bets.build
  end

  def index
    @matches = @matches.latest.includes(:team1_matches, :team2_matches)
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def new; end

  def create
    if @match.save
      flash[:success] = t ".flash_created_match"
      redirect_to league_all_matches_path @match.league
    else
      flash[:danger] = @match.errors.full_messages
      redirect_to league_new_match_path @match.league
    end
  end

  def destroy
    if @match.destroy
      flash[:success] = t ".flash_deleted_match"
    else
      flash[:danger] = t ".flash_delete_failed"
    end
    redirect_to matches_path
  end

  def load_league_matches
    @matches = Match.owned_by(params[:id]).paginate page: params[:page],
      per_page: Settings.per_page
    render :index
  end

  private

  def match_params
    params.require(:match).permit :team1_id, :team2_id, :score1, :score2,
      :day, :start_time, :stadium, :league_id
  end

  def load_all_matches
    @matches = Match.all
  end

  def load_all_filter
    @league_list = League.alphabet.pluck :name, :id
    @status = [Settings.done_pair_value.split(/\W+/), Settings.undone_pair_value.split(/\W+/)]
  end

  def load_filtered_result
    @matches = @matches.owned_by(params[:league_id]) if params[:league_id].present?
    @matches = @matches.by_status(params[:status]) if params[:status].present?
  end

  def load_league_teams
    @team_list = @league.teams.pluck :name, :id
  end

  def load_league
    @league = League.find_by id: params[:id]
    return if @league
    flash[:danger] = t ".not_found_league"
    redirect_to leagues_path
  end

  def load_match
    @match = Match.find_by id: params[:id]
    return if @match
    flash[:danger] = t ".match_not_found"
    redirect_to root_path
  end

  def user_bet user, match
    match.bets.find_by user_id: user.id
  end
end

class BetsController < ApplicationController
  before_action :load_match, only: %i(create update)
  before_action :load_var_for_create, only: :create
  before_action :load_var_for_update, only: :update
  load_and_authorize_resource

  def index; end

  def create
    if have_enough_coin?(current_user, params[:bet][:coin].to_i) && @bet.save
      calculate_coin_for_create
      flash[:success] = t ".bet_success"
    else
      flash[:danger] = t ".bet_failed"
    end
    redirect_to @match
  end

  def update
    if have_enough_coin?(current_user, params[:bet][:coin].to_i, @old_bet_coin) && @bet.update_attributes(bet_params)
      calculate_coin_for_update
      flash[:success] = t ".bet_success"
    else
      flash[:danger] = t ".bet_failed"
    end
    redirect_to @match
  end

  def destroy; end

  private

  def load_match
    @match = Match.find_by id: params[:match_id]
    return if @match
    flash[:danger] = t ".match_not_found"
    redirect_to root_path
  end

  def load_var_for_create
    @bet = @match.bets.build bet_params
    @bet.user_id = current_user.id
  end

  def calculate_coin_for_create
    @coin_left = current_user.coin - params[:bet][:coin].to_i
    current_user.update_attribute :coin, @coin_left
  end

  def load_var_for_update
    @bet = Bet.find_by id: params[:id]
    @old_bet_coin = @bet.coin
  end

  def calculate_coin_for_update
    @coin_left = current_user.coin + @old_bet_coin - params[:bet][:coin].to_i
    current_user.update_attribute :coin, @coin_left
  end

  def bet_params
    params.require(:bet).permit :team, :coin
  end

  def have_enough_coin? user, coin, old_bet_coin = 0
    user.coin + old_bet_coin >= coin
  end
end

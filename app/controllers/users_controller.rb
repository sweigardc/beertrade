class UsersController < ApplicationController
  def show
    @user           = User.find_by_username(params[:id])
    raise ActiveRecord::RecordNotFound unless @user

    if @user == current_user || current_user.try(:moderator?)
      @pending        = @user.trades.not_completed_yet.page(params[:pending_page])
    end

    @completed      = @user.trades.completed.page(params[:completed_page])

    @notifications = if current_user == @user
                       @user.notifications.unseen.page(params[:notification_page])
                     else
                       []
                     end
  end


  def index
    if params[:username_q]
      if @searched_for = User.find_by_username(params[:username_q])
        return redirect_to(@searched_for)
      else
        flash[:alert] = "user not found: #{params[:username_q]}"
      end
    end

    @users = User.top_traders.page(params[:page])
  end
end

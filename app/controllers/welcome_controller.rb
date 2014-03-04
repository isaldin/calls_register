class WelcomeController < ApplicationController
  before_filter :check_if_admin, only: [:search_form, :search]

  def index
    if current_user
      if current_user.is_admin?
        redirect_to search_form_path
      else
        redirect_to user_info_path
      end
    else
      redirect_to login_path
    end
  end

  def search_form
    unless params[:search_start] && params[:search_end]
      params[:search_start] = Date.today.strftime('01-%m-%Y')
      params[:search_end]   = Date.today.strftime('01-%m-%Y')
    end


    @statistic = Statistic.all
  end

  def search
    redirect_to search_form_path( { search_start: params[:search_start],
                                    search_end: params[:search_end],
                                    user_ids: params[:user][:user_ids].map{|user_id| user_id if user_id.present?},
                                  } )

    #User.find(params[:user][:user_ids].map{|user_id| user_id if user_id.present?})
  end

  def user_info
    @user = current_user
  end

  def check_if_admin
    if current_user && current_user.is_admin?
      #
    else
      redirect_to root_path
    end
  end
end

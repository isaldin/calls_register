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

  def report
    respond_to do |format|
      format.xlsx{
        @statistic = []
        search_start = ''
        search_end = ''

        if params[:search_start] && params[:search_end] && params[:users]
          search_start = Date.parse(params[:search_start])
          search_end = Date.parse(params[:search_end])
          user_ids = params[:users].select{|u| u if u.present?}
          params[:users] = user_ids

          @statistic = Statistic.where(day: search_start.beginning_of_month..search_end.end_of_month).where(user_id: user_ids).all
        end

        render :xlsx => "report", :filename => "all_posts.xlsx", locals: { stata: @statistic, s: search_start, e: search_end }
      }
    end
  end

  def search_form
    @statistic = []

    unless params[:search_start] && params[:search_end]
      params[:search_start] = Date.today.strftime('01-%m-%Y')
      params[:search_end]   = Date.today.strftime('01-%m-%Y')
    end

    if params[:search_start] && params[:search_end] && params[:users]
      search_start = Date.parse(params[:search_start])
      search_end = Date.parse(params[:search_end])
      user_ids = params[:users].select{|u| u if u.present?}
      params[:users] = user_ids

      @statistic = Statistic.where(day: search_start.beginning_of_month..search_end.end_of_month).where(user_id: user_ids).order('user_id, day')
    end
  end

  def search
    redirect_to search_form_path( { search_start: params[:search_start],
                                    search_end: params[:search_end],
                                    users: params[:users],
                                  } )
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

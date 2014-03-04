class StatisticController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  respond_to :json

  def index
    user = auth_user

    unless user
      render json: { success: false, error: 'Invalid login data' }
      return
    end

    params[:statistic].each do |record|
      s = Statistic.where(day: Date.parse(record[:day]), user_id: user.id).first_or_initialize

      s.update_attributes(
          count: record[:count],
          duration: record[:duration],
      )

      s.save
    end

    render json: { success: true }
  end

  private

  def auth_user
    User.authenticate params[:login], params[:password]
  end

end

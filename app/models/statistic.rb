class Statistic < ActiveRecord::Base

  belongs_to :user

  attr_accessible :day, :duration, :count, :user_id

end

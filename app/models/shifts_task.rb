class ShiftsTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :shift
end

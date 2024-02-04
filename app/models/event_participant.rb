class EventParticipant < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :event
end

class Task < ApplicationRecord
  enum status: [:todo, :done]
  belongs_to :list
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :name, presence: true
end

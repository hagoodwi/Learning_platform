class MaterialAccess < ApplicationRecord
    belongs_to :material
  
    validates :material_id, presence: true, uniqueness: true
    validates :always_open, inclusion: { in: [true, false] }
    validates :start_time, presence: true, if: -> { !always_open }
    validates :end_time, presence: true, if: -> { !always_open && start_time.present? }
  
    scope :open_now, -> { where(always_open: true).or(where("start_time <= ? AND end_time >= ?", Time.now, Time.now)) }
  end

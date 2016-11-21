class Key < ApplicationRecord

  before_create :set_created

  scope :available, -> { where('status IN (?)', [Key.statuses[:created], Key.statuses[:released]]).alive }

  enum status: {
      created: 0,
      assigned: 1,
      released: 2,
      deleted: 3
  }

  enum renewal_status: {
      dead: 0,
      alive: 1
  }

  def set_assigned!
    if self.created? || (self.released? && (self.assigned_at + 5.minutes > Time.current))
      self.status = :assigned
      self.assigned_at = Time.current
      self.save!
      return true
    else
      self.status = :deleted
      self.deleted_at = Time.current
      self.save!
      return false
    end
  end

  def set_released!
    return false unless self.assigned?
    self.status = :released
    self.released_at = Time.current
    self.save!
    true
  end

  def set_deleted!
    return false if self.deleted?
    self.status = :deleted
    self.renewal_status = :dead
    self.deleted_at = Time.current
    self.save!
    true
  end

  # Method will keep alive a key only if its assigned within last 5 minutes
  # Else it'll delete the key
  def keep_alive!
    if self.alive?
      if self.renewed_at > Time.current + 5.minutes
        self.renewal_status = :dead
        self.status = :deleted
        self.deleted_at = Time.current
        self.save!
        return false
      else
        self.renewed_at = Time.current
        self.save!
        return true
      end
    else
      false
    end
  end

  private
  def set_created
    self.created_at = Time.current
    self.renewed_at = Time.current
    self.renewal_status = :alive
    self.status = :created
  end

end

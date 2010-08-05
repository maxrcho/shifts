class PayformItem < ActiveRecord::Base
  versioned
  
  # acts_as_tree - replaced by 'versioned'
  
  # acts_as_ascii_tree
  #     /\
  #    / .\
  #   / . .\
  #  /______\
  #    |__|

  has_and_belongs_to_many :payforms
  belongs_to :payform
  #belongs_to :payform_item_set
  belongs_to :category

  delegate :user, :to => :payform
  
  before_validation :unsubmit_payform #note -- perhaps this is not the best place to unsubmit
  
  validates_presence_of :date, :category_id
  validates_numericality_of :hours, :greater_than => 0
  validates_presence_of :description
  validate :length_of_description
  validates_presence_of :reason, :on => :update
  validate :length_of_reason, :on => :update

  named_scope :group, :conditions => {:group =>  false}
  named_scope :active, :conditions => {:active =>  true}
  named_scope :in_category, lambda { |category| { :conditions => {:category_id => category.id}}}
  
  def add_errors(e)
    e = e.to_s.gsub("Validation failed: ", "")
    e.split(", ").each do |error| 
      errors.add_to_base(error)
    end
  end
  
  def department
    if self.group
      self.payforms.first.department
    else
      self.payform.department
    end
  end

  def users
    self.payforms.map{|p| p.user }
  end
  
  protected
  
  def unsubmit_payform
    failed = []
    if self.group
      for p_id in self.payforms.map{|pf| pf.id}
        p = Payform.find(p_id)
        p.submitted = nil
        unless p.save
          failed << p
        end
      end
    else
      self.payform.submitted = nil
      unless self.payform.save
        failed << self.payform
      end
    end
    failed #return an array of failed payform items
  end

  def length_of_description
    min = self.department.department_config.description_min.to_i 
    errors.add(:description, "must be at least #{min} characters long.") if self.description.length < min
  end 
  
  def length_of_reason
    min = self.department.department_config.reason_min.to_i 
    errors.add(:reason, "must be at least #{min} characters long.") if self.reason && self.reason.length < min
  end 
  
  def validate
    errors.add(:date, "cannot be in the future") if self.date && self.date > Date.today
  end

end


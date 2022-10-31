class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  self.abstract_class = true

  def self.generate_uuid
    ActiveRecord::Base.connection.execute("select UUID();").first[0]
  end
end

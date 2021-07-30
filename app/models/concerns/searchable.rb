module Searchable
  extend ActiveSupport::Concern
  # Requires a field search_field_set set in inheriting class set to work
  # requires the following in the calling model:
  # Assumes Mongo 2.6+
  # 
  # index({ search_data: "text" })
  # def search_field_set
  #   [:whitelisted, :fields, :of_document]
  # end    

  included do
    field :search_data, type: String

    before_save :set_searchable_data
  end

  def search_field_set
    []
  end

  def set_searchable_data
    unless search_field_set.empty?
      search_data = []
      search_field_set.each do |f|
        search_data << self.send(f)
      end
      self.search_data = search_data.join(" ")
    end
  end
end

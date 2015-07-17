class PrioritizeItems
  def self.call(items:, ids_in_order:)
    ids_in_order[0..-2].each_with_index do |item_id, index|
      items.find(item_id).update_attribute(:priority, index+1)
    end
  end
end



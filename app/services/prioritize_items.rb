class PrioritizeItems

  def self.call(items:, ids_in_order:)
    ids_in_order.pop
    ids_in_order.each_with_index do |item_id, index|
      items.find(item_id).update_attribute(:priority, index+1)
    end
  end

end



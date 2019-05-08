class ItemSerializer < ActiveModel::Serializer
    attributes :id, :quantity
    belongs_to :product
    # def items
    #   { id: self.object.id,
    #     quantity: self.object.quantity
    #     # product: self.object.product
    #   }
    # end
end

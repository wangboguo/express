class Store::OrderInfo < ActiveRecord::Base
  belongs_to :order, :class_name => "Store::Order", :foreign_key => "order_id"
end

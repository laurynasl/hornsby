ActiveRecord::Schema.define(:version => 0) do
  create_table :fruits, :force => true do |t|
    t.string :species
    t.integer :average_diameter
  end
end

class CreateBasicPredicates < ActiveRecord::Migration
  def change
    create_table :basic_predicates do |t|
      t.belongs_to :rule
      t.string :name
    end
  end
end

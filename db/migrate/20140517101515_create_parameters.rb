class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.belongs_to :basic_predicate
      t.string :name
    end
  end
end

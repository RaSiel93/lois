class CreateConstants < ActiveRecord::Migration
  def change
    create_table :constants do |t|
      t.belongs_to :fact
      t.string :name
    end
  end
end

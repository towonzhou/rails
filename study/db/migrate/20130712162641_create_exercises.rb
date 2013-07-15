class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :title
      t.string :text
      t.string :file_in
      t.string :file_out
      t.string :code

      t.timestamps
    end
  end
end

class CreateMobiles < ActiveRecord::Migration
  def change
    create_table :mobiles do |t|
      t.string :real_mobile, unique: true

      t.timestamps
    end

    execute "CREATE SEQUENCE tokens_vir_mobile_seq START 20000000001"
  end
end

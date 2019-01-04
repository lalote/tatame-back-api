class AddResumenFromFighter < ActiveRecord::Migration[5.2]
  def change
    add_column :fighters, :resumen, :string, default: ''
  end
end

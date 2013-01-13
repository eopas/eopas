ActiveRecord::Schema.define(:version => 1) do
  create_table :videos, :force => true do |t|
    t.string :file_file_name
    t.string :file_content_type
    t.string :file_file_size
    t.string :file_updated_at

    t.timestamps
  end

  create_table :delayed_jobs, :force => true do |t|
    t.integer  :priority, :default => 0
    t.integer  :attempts, :default => 0
    t.text     :handler
    t.text     :last_error
    t.datetime :run_at
    t.datetime :locked_at
    t.datetime :failed_at
    t.string   :locked_by
    t.timestamps
  end
end

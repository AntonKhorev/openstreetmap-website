class BackfillNoteSubscriptions < ActiveRecord::Migration[7.2]
  class Note < ApplicationRecord; end

  disable_ddl_transaction!

  def up
    Note.in_batches(:of => 100) do |notes|
      safety_assured do
        sql_command = <<-SQL.squish
          INSERT INTO note_subscriptions (user_id, note_id)
            SELECT DISTINCT author_id, note_id
            FROM note_comments
            WHERE
              author_id IS NOT NULL AND
              #{ApplicationRecord.sanitize_sql ['note_id IN (?)', notes.ids]}
          ON CONFLICT DO NOTHING
        SQL

        execute(sql_command)
      end
    end
  end
end

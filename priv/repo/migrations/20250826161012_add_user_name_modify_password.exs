defmodule Livechat.Repo.Migrations.AddUserName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false
      modify :hashed_password, :string, null: false
    end
  end

  def down do
    alter table(:users) do
      remove :name
      modify :hashed_password, :string, null: true
    end
  end
end

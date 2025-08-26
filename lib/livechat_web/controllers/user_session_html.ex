defmodule LivechatWeb.UserSessionHTML do
  use LivechatWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:livechat, Livechat.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end

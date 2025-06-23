defmodule GateRushWeb.Pow.SessionHTML do
  use GateRushWeb, :html

  embed_templates "session_html/*"

  def error_tag(form, field) do
    if form.action do
      if error = form.errors[field] do
        assigns = %{message: translate_error(error)}

        ~H"""
        <p class="mt-1 text-sm text-red-600 dark:text-red-500">
          <%= @message %>
        </p>
        """
      end
    end
  end

end

defmodule Leuchtturm.Web.Utilities.Errors do
  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag

  def error_tag(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
    |> dbg()
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(Leuchtturm.Web.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Leuchtturm.Web.Gettext, "errors", msg, opts)
    end
  end
end

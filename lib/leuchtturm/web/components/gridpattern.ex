defmodule Leuchtturm.Web.Components.GridPattern do
  use Leuchtturm.Web, :html

  def grid_pattern(assigns) do
    assigns =
      %{pattern_id: gen_reference()}
      |> Map.merge(assigns)

    ~H"""
    <svg aria-hidden="true" class="absolute inset-0 w-full h-full">
      <defs>
        <pattern id={@pattern_id} width="128" height="128" patternUnits="userSpaceOnUse" {assigns}>
          <path d="M0 128V.5H128" fill="none" stroke="currentColor" />
        </pattern>
      </defs>
      <rect width="100%" height="100%" fill={"url(\##{@pattern_id})"} />
    </svg>
    """
  end

  def gen_reference() do
    min = String.to_integer("100000", 36)
    max = String.to_integer("ZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end
end

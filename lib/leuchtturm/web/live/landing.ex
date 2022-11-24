defmodule Leuchtturm.Web.LandingLive do
  use Leuchtturm.Web, :live_view

  import Leuchtturm.Web.Components.GridPattern

  @impl true
  def render(assigns) do
    ~H"""
    <.hero />
    """
  end

  defp hero(assigns) do
    ~H"""
    <header class="overflow-hidden lg:px-5 lg:bg-transparent bg-slate-100">
      <div class="grid grid-cols-1 gap-y-16 pt-16 mx-auto max-w-6xl md:pt-20 lg:grid-cols-12 lg:gap-y-20 lg:px-3 lg:pt-20 lg:pb-36 xl:py-32 grid-rows-[auto_1fr]">
        <div class="flex relative items-end lg:col-span-5 lg:row-span-2">
          <div class="absolute left-0 -bottom-12 -top-20 right-1/2 z-10 bg-blue-600 md:bottom-8 lg:-inset-y-32 lg:right-full lg:-mr-40 rounded-br-6xl text-white/10 lg:left-[-100vw]">
            <.grid_pattern x="100%" y="100%" patternTransform="translate(112 64)" />
          </div>
          <div class="flex relative z-10 mx-auto w-64 rounded-xl shadow-xl md:w-80 lg:w-auto bg-slate-600">
          </div>
        </div>
        <div class="relative px-4 sm:px-6 lg:col-span-7 lg:pr-0 lg:pb-14 lg:pl-16 xl:pl-20">
          <div class="hidden lg:block lg:absolute lg:bottom-0 lg:-top-32 lg:right-[-100vw] lg:left-[-100vw] lg:bg-slate-100" />
        </div>
        <div class="pt-16 bg-white lg:col-span-7 lg:pt-0 lg:pl-16 lg:bg-transparent xl:pl-20">
          <div class="px-4 mx-auto sm:px-6 md:px-4 md:max-w-2xl lg:px-0">
            <h1 class="text-5xl font-extrabold sm:text-6xl font-display text-slate-900">
              Get lost in the world of icon design.
            </h1>
            <p class="mt-4 text-3xl text-slate-600">
              A book and video course that teaches you how to design your own
              icons from scratch.
            </p>
            <div class="flex gap-4 mt-8">
            </div>
          </div>
        </div>
      </div>
    </header>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

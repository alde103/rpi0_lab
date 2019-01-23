defmodule Rpi0Lab.Animate do
  alias Nerves.Neopixel
  alias Nerves.Neopixel.{
    Color,
    HAL,
    Point
  }

  require Logger

  @neopixel_config Application.get_env(:nerves_neopixel, :config)
  def color(:status, opts) do
    {r, g, b, w} = opts[:color] || {255, 255, 255, 255}
    #Neopixel.fill(%Point{x: 0, y: 0}, 7, 1,%Color{r: r, g: g, b: b, w: w})
    #Neopixel.render()
  end

  def color(:valiot, opts) do
    {r, g, b, w} = opts[:color] || {255, 255, 255, 255}
    #Neopixel.set_pixel(%Point{x: 0, y: 1}, %Color{r: r, g: g, b: b, w: w})
    #Neopixel.set_pixel(%Point{x: 1, y: 1}, %Color{r: r, g: g, b: b, w: w})
    #Neopixel.set_pixel(%Point{x: 2, y: 1}, %Color{r: r, g: g, b: b, w: w})
    #Neopixel.set_pixel(%Point{x: 3, y: 1}, %Color{r: r, g: g, b: b, w: w})
    #Neopixel.set_pixel(%Point{x: 4, y: 1}, %Color{r: r, g: g, b: b, w: w})
    #Neopixel.render()
  end

  def color(atom, _opts) do
    Logger.error("#{__MODULE__} Invalid atom: #{atom}")
  end

  def pulse(lightpipe, delay \\ 1000) do
    spawn(fn -> pulse_indef(lightpipe, 5, delay, :up) end)
  end

  def pulse_indef(lightpipe, 5, delay, :down) do
    pulse_indef(lightpipe, 5, delay, :up)
  end

  def pulse_indef(lightpipe, 255, delay, :up) do
    pulse_indef(lightpipe, 255, delay, :down)
  end

  def pulse_indef(lightpipe, brightness, delay, direction) do
    data = Tuple.duplicate(brightness, 4)
    color(lightpipe, color: data)
    :timer.sleep(delay)
    brightness = if direction == :up, do: brightness + 25, else: brightness - 25
    pulse_indef(lightpipe, brightness, delay, direction)
  end

  #auxiliar function for library bugs
  @spec init_neopixels() :: {:ok, pid()}
  def init_neopixels() do
    {:ok, pid} = HAL.start_link(config: @neopixel_config)
    {:ok, pid}
  end
end

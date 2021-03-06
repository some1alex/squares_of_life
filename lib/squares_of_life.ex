defmodule KV.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do

    children = [
      worker(Entity, [], [name: Entity])
    ]

    supervise(children, strategy: :one_for_one)
  end


  """
  def createAgents do
    {:ok, pid} = Agent.start_link(fn -> %{} end)
    Agent.update(pid, &Map.put(&1, :hello, :world))
    Agent.get(pid, &Map.get(&1, :hello))
  end
  """
end


defmodule Loop do
   def for_test(toNumber, message) do
      efor(toNumber, message)
   end
   defp efor(toNumber, message) do
     if not(toNumber == 0) do
       IO.puts(message)
       efor(toNumber-1,message)
     end
   end
end




defmodule Entity do
  def start_link do
    Agent.start_link(fn -> %{} end)
  end
 
  def placeAt(pid, x, y) do
    Agent.update(pid, &Map.put(&1, "position", [x, y]))
  end

  def moveWith(pid, onX, onY) do
    case onX!=1 do
        true -> 
          raise "Can only move by 1 space!"
        _ -> case onY!=1 do
                true -> 
                  raise "Can only move by 1 space!"
                _ -> 
                  Agent.update(pid, &Map.put(&1, "position", [onX, onY]))
             end
      end
  end
 
  def getLocation(pid) do
    Agent.get(pid, &Map.get(&1, "position"))
  end

  def printLocation(pid) do
    value = Agent.get(pid, &Map.get(&1, "position"))
  end
end





defmodule Randomize do
  def random(number) do
    :random.seed(:os.timestamp()) 
    :random.uniform(number)
  end
end





defmodule SquaresOfLife do
  @behaviour :wx_object
  use Bitwise

  @title 'Elixir OpenGL'
  @size {600, 600}


  #######
  # API #
  #######
  def start() do
    :wx_object.start_link(__MODULE__, [], [])
  end





  #################################
  # :wx_object behavior callbacks #
  #################################
  def init(config) do
    wx = :wx.new(config)
    frame = :wxFrame.new(wx, :wx_const.wx_id_any, @title, [{:size, @size}])
    :wxWindow.connect(frame, :close_window)
    :wxFrame.show(frame)

    opts = [{:size, @size}]
    gl_attrib = [{:attribList, [:wx_const.wx_gl_rgba,
                                :wx_const.wx_gl_doublebuffer,
                                :wx_const.wx_gl_min_red, 8,
                                :wx_const.wx_gl_min_green, 8,
                                :wx_const.wx_gl_min_blue, 8,
                                :wx_const.wx_gl_depth_size, 24, 0]}]
    canvas = :wxGLCanvas.new(frame, opts ++ gl_attrib)

    :wxGLCanvas.connect(canvas, :size)
    :wxWindow.reparent(canvas, frame)
    :wxGLCanvas.setCurrent(canvas)
    setup_gl(canvas)

    # Periodically send a message to trigger a redraw of the scene
    timer = :timer.send_interval(20, self(), :update)

    {frame, %{canvas: canvas, timer: timer}}
  end



  def code_change(_, _, state) do
    {:stop, :not_implemented, state}
  end

  def handle_cast(msg, state) do
    IO.puts "Cast:"
    IO.inspect msg
    {:noreply, state}
  end

  def handle_call(msg, _from, state) do
    IO.puts "Call:"
    IO.inspect msg
    {:reply, :ok, state}
  end

  def handle_info(:stop, state) do
    :timer.cancel(state.timer)
    :wxGLCanvas.destroy(state.canvas)
    {:stop, :normal, state}
  end

  def handle_info(:update, state) do
    :wx.batch(fn -> render(state) end)
    {:noreply, state}
  end

  # Example input:
  # {:wx, -2006, {:wx_ref, 35, :wxFrame, []}, [], {:wxClose, :close_window}}
  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  def handle_event({:wx, _, _, _, {:wxSize, :size, {width, height}, _}}, state) do
    if width != 0 and height != 0 do
      resize_gl_scene(width, height)
    end
    {:noreply, state}
  end

  def terminate(_reason, state) do
    :wxGLCanvas.destroy(state.canvas)
    :timer.cancel(state.timer)
    :timer.sleep(100)
  end




  #####################
  # Private Functions #
  #####################
  defp setup_gl(win) do
    {w, h} = :wxWindow.getClientSize(win)
    resize_gl_scene(w, h)
    :ok
  end

  defp resize_gl_scene(width, height) do
    :gl.viewport(0, 0, width, height)
    :gl.matrixMode(:gl_const.gl_projection)
    :gl.loadIdentity()
    :ok
  end




  defp draw() do
    :gl.viewport(0, 0, 600, 600)
    :gl.matrixMode(:gl_const.gl_projection)
    :gl.loadIdentity()
    :glu.ortho2D(-1, 1, -1, 1)
    :gl.begin(:gl_const.gl_quads)
    :gl.vertex2f(-0.5, -0.5)
    :gl.vertex2f( 0.5, -0.5)
    :gl.vertex2f( 0.5, 0.5)
    :gl.vertex2f(-0.5, 0.5)
    :gl.end()
    :ok
  end

  defp render(%{canvas: canvas} = _state) do
    draw()
    :wxGLCanvas.swapBuffers(canvas)
    :ok
  end
end
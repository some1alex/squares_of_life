-module(gl_const).
-compile(export_all).

-include_lib("wx/include/gl.hrl").

gl_smooth() ->
  ?GL_SMOOTH.

gl_depth_test() ->
  ?GL_DEPTH_TEST.

gl_lequal() ->
  ?GL_LEQUAL.

gl_perspective_correction_hint() ->
  ?GL_PERSPECTIVE_CORRECTION_HINT.

gl_nicest() ->
  ?GL_NICEST.

gl_color_buffer_bit() ->
  ?GL_COLOR_BUFFER_BIT.

gl_depth_buffer_bit() ->
  ?GL_DEPTH_BUFFER_BIT.

gl_triangles() ->
  ?GL_TRIANGLES.

gl_polygon() ->
  ?GL_POLYGON.

gl_projection() ->
  ?GL_PROJECTION.

gl_modelview() ->
  ?GL_MODELVIEW.


gl_lines() ->
  ?GL_LINES.

gl_line() ->
  ?GL_LINE.

gl_quads() ->
  ?GL_QUADS.

gl_front_and_back() ->
  ?GL_FRONT_AND_BACK.
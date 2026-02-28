Wi.killProcesses() // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: trail_renderer.lua")

trail := Wi.TrailRenderer()
trail.SetWidth(0.2)
trail.SetColor(Wi.Vector(10,0.1,0.1,1))
trail.SetBlendMode(Wi.BLENDMODE_ADDITIVE)
trail.SetSubdivision(100)

[
  // Trail begins as red:
  (Wi.Vector(-5,2,-3), 4, Wi.Vector(10,0.1,0.1,1)),
  (Wi.Vector(5,1,1), 0.5, Wi.Vector(10,0.1,0.1,1)),
  (Wi.Vector(10,5,4), 1.2, Wi.Vector(10,0.1,0.1,1)),
  (Wi.Vector(6,8,2), 1, Wi.Vector(10,0.1,0.1,1)),
  (Wi.Vector(-6,5,0), 1, Wi.Vector(10,0.1,0.1,1)),
  // Trail turn into green:
  (Wi.Vector(0,2,-5), 1, Wi.Vector(0.1,100,0.1,1)),
  (Wi.Vector(1,3,5), 1, Wi.Vector(0.1,100,0.1,1)),
  (Wi.Vector(-3,2,8), 1, Wi.Vector(0.1,100,0.1,1)),
] (_, (pos, width, color)) ->
  trail.AddPoint(pos, width, color);

trail.Cut() // start a new trail without connecting to previous points

[
  // Last trail segment is blue:
  (Wi.Vector(-5,0,-2), 1, Wi.Vector(0.1,0.1,100,1)),
  (Wi.Vector(5,8,5), 1, Wi.Vector(0.1,0.1,100,1)),
] (_, (pos, width, color)) ->
  trail.AddPoint(pos, width, color);

// First texture is a circle gradient, this makes the overall trail smooth at the edges:
texture := Wi.texturehelper.CreateGradientTexture(
  Wi.GradientType.Circular,
  256, 256,
  Wi.Vector(0.5, 0.5), Wi.Vector(0.5, 0),
  GradientFlags.Inverse,
  "rrrr",
)
trail.SetTexture(texture)

// Second texture is a linear gradient that will be tiled and animated to achieve stippled look:
texture2 := Wi.texturehelper.CreateGradientTexture(
  Wi.GradientType.Linear,
  256, 256,
  Wi.Vector(0.5, 0), Wi.Vector(0, 0),
  Wi.GradientFlags.Inverse | Wi.GradientFlags.Smoothstep,
  "rrrr",
)
trail.SetTexture2(texture2)

Wi.runProcess(->
  scrolling := 0
  true ->
    scrolling -= Wi.getDeltaTime()
    trail.SetTexMulAdd2(Wi.Vector(10,1, scrolling, 0))
    Wi.DrawTrail(trail)
    Wi.render() // this loop will be blocked until render tick
)

Wi.backlog_post("---> END SCRIPT: trail_renderer.lua")

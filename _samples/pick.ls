// This script will load a teapot model and demonstrate picking it with a ray
Wi.killProcesses() // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: pick.lua")

scene := Wi.GetScene()
scene.Clear()
model_entity := Wi.LoadModel(Wi.script_dir() + "../models/teapot.wiscene")

Wi.runProcess(->
  t := 0
  true ->
    t += 0.02

    // Create a Ray by specifying origin and direction (and also animate the ray origin along sine wave):
    ray := Wi.Ray(Wi.Vector(Wi.math.sin(t) * 4,1,-10), Wi.Vector(0,0,1))
    (entity, position, normal, distance) := Wi.Pick(ray)

    ?| entity != Wi.INVALID_ENTITY
      // Draw intersection point as purple X
      Wi.DrawPoint(position, 1, Wi.Vector(1,0,1,1))

    // Draw ray as yellow line:
    Wi.DrawLine(ray.GetOrigin(), ray.GetOrigin().Add(ray.GetDirection().Multiply(1000)), Wi.Vector(1,1,0,1))

    Wi.render()
)

Wi.backlog_post("---> END SCRIPT: pick.lua")

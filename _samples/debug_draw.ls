// This script will draw some debug primitives in the world such as line, point, box, capsule, text
Wi.killProcesses()  // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: debug_draw.lua")

Wi.runProcess(->
  true ->
    Wi.DrawLine(Wi.Vector(-10,4,0), Wi.Vector(10,1,1), Wi.Vector(1,0,1,1))
    Wi.DrawPoint(Wi.Vector(0,4,0), 3, Wi.Vector(1,1,0,1))

    s := Wi.matrix.Scale(Wi.Vector(1,2,3))
    r := Wi.matrix.Rotation(Wi.Vector(0.2, 0.6))
    t := Wi.matrix.Translation(Wi.Vector(0,2,3))
    m := s.Multiply(r).Multiply(t)
    Wi.DrawBox(m, Wi.Vector(0,1,1,1))

    capsule := Wi.Capsule(Wi.Vector(1,1,1), Wi.Vector(30,30,30), 1.5)
    Wi.DrawCapsule(capsule, Wi.Vector(1,0,0,1))

    Wi.DrawDebugText("Debug text", Wi.Vector(-5,4,2), Wi.Vector(0,1,0,1), 2, Wi.DEBUG_TEXT_CAMERA_FACING | Wi.DEBUG_TEXT_CAMERA_SCALING)
    Wi.DrawDebugText("Debug text behind", Wi.Vector(-5,4,4), Wi.Vector(0,0,1,1), 2, Wi.DEBUG_TEXT_CAMERA_FACING | Wi.DEBUG_TEXT_CAMERA_SCALING)

    Wi.render()
)

Wi.backlog_post("---> END SCRIPT: debug_draw.lua")

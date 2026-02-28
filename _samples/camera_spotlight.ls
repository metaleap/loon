// This script will add a spot light fixed to camera

Wi.backlog_post("---> START SCRIPT: camera_spotlight.lua")

scene := GetScene()

runProcess(->
  light_entity := Wi.CreateEntity()
  scene.Component_CreateLight(light_entity)

  light := scene.Component_GetLight(light_entity)
  light.SetType(Wi.SPOT)
  light.SetRange(100)
  light.SetEnergy(8)
  light.SetFOV(Wi.math.pi / 3.0)
  light.SetColor(Vector(1,0.7,0.8))

  scene.Component_CreateTransform(light_entity)

  true ->
    cam := Wi.GetCamera()
    cam_pos := cam.GetPosition()
    cam_look := cam.GetLookDirection()
    cam_up := cam.GetUpDirection()
    light_pos := scene.Component_GetTransform(light_entity)
    ?| light_pos == nil
      <- Wi.backlog_post("light no longer exists, exiting script")
    light_pos.ClearTransform()
    light_pos.Rotate(Vector(-Wi.math.pi / 2.0, 0, 0)) // spot light was facing downwards by default, rotate it to face +Z like camera default
    //light_pos.MatrixTransform(cam.GetInvView())
    light_pos.MatrixTransform(Wi.matrix.Inverse(Wi.matrix.LookTo(cam_pos, cam_look, cam_up))) // This is similar to cam.GetInvView()

    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: camera_spotlight.lua")

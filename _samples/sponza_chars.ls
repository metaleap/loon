lhs |> rhs := rhs(lhs)

sponza_path := Wi.script_dir() + "/art/Sponza/Sponza.wiscene"

Wi.runProcess(main)

main := ()
  scene := Wi.GetScene()
  cam := Wi.GetCamera()
  cam.SetFOV(45 * (Wi.math.pi / 180)) // deg2rad

  Wi.LoadModel(sponza_path)
  emitter := scene.Entity_FindByName("editorEmitter")
  ?| emitter != INVALID_ENTITY
    scene.Entity_Remove(emitter)

  cam_transform := Wi.TransformComponent()
  cam_transform.Translate(Wi.Vector(0, 2, 0))

  true ->
    Wi.update()
    dt := Wi.getDeltaTime()

    diff := Wi.input.GetAnalog(GAMEPAD_ANALOG_THUMBSTICK_R)
    diff = Wi.vector.Multiply(diff, dt * 4)
    mouseDiff := Wi.input.GetPointerDelta()
    mouseDiff = mouseDiff.Multiply(0.01)
    diff = Wi.vector.Add(diff, mouseDiff)
    cam_transform.Rotate(Wi.Vector(diff.GetY(), diff.GetX()))

    camspeed := 4.567 * dt
    camera_movement := Wi.Vector()
    ?| Wi.input.Down('W')
      camera_movement = Wi.vector.Add(camera_movement, Wi.Vector(0, 0, camspeed))
    ?| Wi.input.Down('S')
      camera_movement = Wi.vector.Add(camera_movement, Wi.Vector(0, 0, -camspeed))
    ?| Wi.input.Down('A')
      camera_movement = Wi.vector.Add(camera_movement, Wi.Vector(-camspeed, 0, 0))
    ?| Wi.input.Down('D')
      camera_movement = Wi.vector.Add(camera_movement, Wi.Vector(camspeed, 0, 0))
    ?| Wi.input.Down('Q')
      camera_movement = Wi.vector.Add(camera_movement, Wi.Vector(0, -camspeed, 0))
    ?| Wi.input.Down('E')
      camera_movement = Wi.vector.Add(camera_movement, Wi.Vector(0, camspeed, 0))

    camera_movement = Wi.vector.Rotate(camera_movement, cam_transform.Rotation_local) // rotate the camera movement with camera orientation, so it's relative
    cam_transform.Translate(camera_movement)
    cam_transform.UpdateTransform() // because cam_transform is not part of the scene system, but we created it just in the script, update it manually with UpdateTransform()
    cam.TransformCamera(cam_transform)
    cam.UpdateCamera()

    ?| Wi.IsThisEditor() && Wi.input.Press(KEYBOARD_BUTTON_ESCAPE)
      <- Wi.ReturnToEditor()

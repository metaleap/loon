// This script will play a camera shake effect

(camera, shake_offset) := (Wi.GetCamera(), Wi.Vector())
(shake_x, shake_y, shake_elapsed) := (-1, -1, 0)

// Outside settable params:
@camShakeAmount := 0.2
@camShakeFrequency := 0.05
@camShakeAggressiveness := 0.1

Wi.runProcess(->
  true ->
    ?| Wi.input.Press(Wi.KEYBOARD_BUTTON_F6)
      @camShakeAmount = (@camShakeAmount > 0) ? 0 : 0.1
    ?| shake_elapsed > @camShakeFrequency
      shake_elapsed = 0
      ?| @camShakeAmount <= 0
        shake_offset = Wi.Vector()
      |?
        (shake_x, shake_y) = (shake_x * -1, shake_y * -1)
        (up, fwd) := (camera.GetUpDirection(), camera.GetLookDirection())
        side := Wi.vector.Cross(up, fwd)
        shake_offset = Wi.vector.Add(
          Wi.vector.Multiply(side, Wi.math.random() * shake_x * @camShakeAmount),
          Wi.vector.Multiply(up, Wi.math.random() * shake_y * @camShakeAmount),
        )
    shake_elapsed += Wi.getDeltaTime()

    pos := camera.GetPosition()
    pos = Wi.vector.Lerp(pos, Wi.vector.Add(pos, shake_offset), @camShakeAggressiveness)
    camera.SetPosition(pos)
    camera.UpdateCamera()
    Wi.update()
)

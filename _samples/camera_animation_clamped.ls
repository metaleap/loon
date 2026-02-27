// This script will play a camera animation chain from "cam0" -to "camN" named camera proxies in the scene
// To use this, first place four cameras into the scene and name them cam0, cam1, cam2 and cam3, then press F8 to start
// The animation will repeat infinitely, but it will cut from last to first proxy at the end

// Get the main camera:
cam := Wi.GetCamera()

// This will be the transform that we grab the camera by:
target := Wi.TransformComponent()

// Get the main scene:
scene := Wi.GetScene()

// Camera speed overridable from outer scope too:
scriptableCameraSpeed := 0.4

// Animation state:
tt := 0.0
play := false
rot := 0
toggleCameraAnimation() :=
  tt = 0.0
  play = !play
  rot = 0

// Gather camera proxy entities in the scene from "cam0" to "cam1", "cam2", ... "camN":
proxies := []
  i := 0
  (it := scene.Entity_FindByName("cam${i}")) != INVALID_ENTITY ->
    proxies[i] = it
    i += 1

Wi.runProcess( ->
  true ->
    ?| Wi.input.Press(Wi.KEYBOARD_BUTTON_F8)
      toggleCameraAnimation()

    ?| play
      // Play animation:
      count := proxies.len

      // Place main camera on spline:
      a := scene.Component_GetTransform(proxies[Wi.math.clamp(rot - 1, 0, count - 1) + 1])
      b := scene.Component_GetTransform(proxies[Wi.math.clamp(rot, 0, count - 1) + 1])
      c := scene.Component_GetTransform(proxies[Wi.math.clamp(rot + 1, 0, count - 1) + 1])
      d := scene.Component_GetTransform(proxies[Wi.math.clamp(rot + 2, 0, count - 1) + 1])
      target.CatmullRom(a, b, c, d, tt)
      target.UpdateTransform()
      cam.TransformCamera(target)
      cam.UpdateCamera()

      // Advance animation state:
      tt += scriptableCameraSpeed * getDeltaTime()
      ?| tt >= 1.0
        tt = 0.0
        rot += 1
      ?| rot >= count - 1
        rot = 0

    // Wait for render() tick from Engine
    // We should wait for update() normally, but Editor tends to update the camera already from update()
    //   and it would override the scrips...
    render()
)

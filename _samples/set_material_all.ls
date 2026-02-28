// You can use this script to iterate through all materials in the scene and set the same parameters for each one
Wi.backlog_post("---> START SCRIPT: set_material_all.lua")

GetScene().Component_GetMaterialArray() (i, material) ->
  material.SetBaseColor(Wi.Vector(1,1,1,1))

Wi.backlog_post("---> END SCRIPT: set_material_all.lua")

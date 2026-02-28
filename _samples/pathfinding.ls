Wi.killProcesses()  // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: pathfinding.lua")

// Create a simple voxel grid by inserting some shapes manually:
voxelgrid := Wi.VoxelGrid(64, 64, 64)
voxelsize := voxelgrid.GetVoxelSize()
voxelsize = Wi.vector.Multiply(voxelsize, 0.5) // reduce the voxelsize by half
voxelgrid.SetVoxelSize(voxelsize)
voxelgrid.InjectTriangle(Wi.Vector(-10, 0, -10), Wi.Vector(-10, 0, 10), Wi.Vector(10, 0, -10))
voxelgrid.InjectTriangle(Wi.Vector(-10, 0, 10), Wi.Vector(10, 0, 10), Wi.Vector(10, 0, -10))
voxelgrid.InjectAABB(AABB(Wi.Vector(4, 0, -2), Wi.Vector(4.5, 4, 5)))
voxelgrid.InjectAABB(AABB(Wi.Vector(4, 0, 0.8), Wi.Vector(8, voxelsize.GetY() * 2, 5)))
voxelgrid.InjectAABB(AABB(Wi.Vector(4, 0, 3), Wi.Vector(8, voxelsize.GetY() * 3.5, 7)))
voxelgrid.InjectAABB(AABB(Wi.Vector(4, 0, 6), Wi.Vector(8, voxelsize.GetY() * 4.5, 7)))
voxelgrid.InjectSphere(Wi.Sphere(Wi.Vector(-4.8,1.6,-2.5), 1.6))
voxelgrid.InjectCapsule(Wi.Capsule(Wi.Vector(4.8,-0.6,-2.5), Wi.Vector(2, 1, 1), 0.4))

// If teapot model can be loaded, then load it and voxelize it too:
scene := Scene()
entity := Wi.LoadModel(scene, script_dir() + "../models/teapot.wiscene", Wi.matrix.RotationY(Wi.math.pi * 0.6))
?| entity != Wi.INVALID_ENTITY
  scene.Entity_GetObjectArray() (i, entity) ->
    scene.VoxelizeObject(i, voxelgrid)

// Create a path query to find paths from start to goal position on voxel grid:
pathquery := Wi.PathQuery()
pathquery.SetDebugDrawWaypointsEnabled(true) // enable waypoint voxel highlighting in DrawPathQuery()
start := Wi.Vector(-7.63,0,-2.6) // world space coordinates can be given
goal := Wi.Vector(6.3,voxelsize.GetY() * 4.5, 6.5) // world space coordinates can be given
pathquery.Process(start, goal, voxelgrid) // this computes the path

Wi.runProcess(->
  true ->
    Wi.DrawVoxelGrid(voxelgrid)
    Wi.DrawPathQuery(pathquery)
    Wi.render() // this loop will be blocked until render tick
)

Wi.backlog_post("---> END SCRIPT: pathfinding.lua")

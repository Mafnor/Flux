-- // Loaded Modules

local Flux = require(PathToFlux)

-- // Private Variables

local originalVector = Vector3.new(5,2,5.3)

-- // Constant Variables

local COORDINATE_BYTE_SIZE = 4

-- // Example

local vectorFlux = Flux.new(COORDINATE_BYTE_SIZE * 3)

vectorFlux:WriteFloat32(originalVector.X)
vectorFlux:WriteFloat32(originalVector.Y)
vectorFlux:WriteFloat32(originalVector.Z)

vectorFlux:ResetCursor()

local newVector = Vector3.new(vectorFlux:ReadFloat32(), vectorFlux:ReadFloat32(), vectorFlux:ReadFloat32())

print(`Original Vector: {originalVector}')
print(`New Vector: {newVector}')

--[[

	Flux
	Mafnorr - 08/21/2025
	
	Allows for easy writing to buffers.
	
	Functions:
	
		Flux.new(sizeInBytes: number): Flux
		Flux.fromBuffer(value: buffer): Flux
		
	Methods [Flux]:
	
		Flux:Reset()
		
		Flux:GetBuffer(): buffer
		Flux:SetBuffer(value: buffer)
		Flux:GetCursor(): number
		Flux:SetCursor(position: number)
		Flux:ResetCursor()
		
		Flux:WriteBits(width: number, value: number)
		Flux:ReadBits(width: number): number
		
		Flux:WriteBool(value: boolean)
		Flux:ReadBool(): boolean
		
		Flux:WriteInt(width: number, value: number)
		Flux:WriteUInt(width: number, value: number)
		Flux:ReadInt(width: number)
		Flux:ReadUInt(width: number)
		
		Flux:WriteFloat(mantissaBitWidth: number, exponentBitWidth: number, value: number)
		Flux:ReadFloat(mantissaBitWidth: number, exponentBitWidth: number): number
		Flux:ReadFloat16(): number
		Flux:ReadFloat32(): number
		Flux:WriteFloat16(value: number)
		Flux:WriteFloat32(value: number)
		
		Flux:WriteUFloat(mantissaBitWidth: number, exponentBitWidth: number, value: number)
		Flux:ReadUFloat(mantissaBitWidth: number, exponentBitWidth: number): number
		Flux:ReadUFloat16(): number
		Flux:ReadUFloat32(): number
		Flux:WriteUFloat16(value: number)
		Flux:WriteUFloat32(value: number)
		
		Flux:WriteMantissa(width: number, value: number)
		Flux:ReadMantissa(width: number): number

]]

-- // Module Table

local Flux = {}
Flux.__index = Flux

-- // Types

export type Flux = {
	
	Reset: (self: FluxInternal) -> (),
	
	GetBuffer: (self: Flux) -> buffer,
	SetBuffer: (self: Flux, value: buffer) -> (),
	GetCursor: (self: Flux) -> number,
	SetCursor: (self: Flux, index: number) -> (),
	ResetCursor: (self: Flux) -> (),
	
	WriteBits: (self: Flux, width: number, value: number) -> (),
	ReadBits: (self: Flux, width: number) -> number,
	
	WriteBool: (self: Flux, value: boolean) -> (),
	ReadBool: (self: Flux) -> boolean,
	
	WriteInt: (self: Flux, width: number, value: number) -> (),
	WriteUInt: (self: Flux, width: number, value: number) -> (),
	ReadInt: (self: Flux, width: number) -> number,
	ReadUInt: (self: Flux, width: number) -> number,
	
	WriteFloat: (self: Flux, mantissaBitWidth: number, exponentBitWidth: number, value: number) -> (),
	ReadFloat: (self: Flux, mantissaBitWidth: number, exponentBitWidth: number) -> number,
	ReadFloat16: (self: Flux) -> (number),
	ReadFloat32: (self: Flux) -> (number),
	WriteFloat16: (self: Flux, value: number) -> (),
	WriteFloat32: (self: Flux, value: number) -> (),
	
	WriteUFloat: (self: Flux, mantissaBitWidth: number, exponentBitWidth: number, value: number) -> (),
	ReadUFloat: (self: Flux, mantissaBitWidth: number, exponentBitWidth: number) -> number,
	ReadUFloat16: (self: Flux) -> (number),
	ReadUFloat32: (self: Flux) -> (number),
	WriteUFloat16: (self: Flux, value: number) -> (),
	WriteUFloat32: (self: Flux, value: number) -> (),
	
	WriteMantissa: (self: Flux, width: number, value: number) -> (),
	ReadMantissa: (self: Flux, width: number) -> number,
	
}

type FluxInternal = Flux & {
	_buffer: buffer,
	_index: number,
}

-- // Private Variables

local PowerOfTwo = setmetatable({}, {

	__index = function(self, Index)

		local Value = 2 ^ Index
		self[Index] = Value

		return Value

	end;

})

-- // Methods

function Flux.Reset(self: FluxInternal)
	
	self:ResetCursor()
	
	-- // Dumps the buffer
	
	buffer.fill(self._buffer, 0, 0, buffer.len(self._buffer))
	
end

function Flux.GetBuffer(self: FluxInternal): buffer
	return self._buffer
end

function Flux.SetBuffer(self: FluxInternal, value: buffer)
	self._buffer = value
end

function Flux.GetCursor(self: FluxInternal): number
	return self._index
end

function Flux.SetCursor(self: FluxInternal, position: number)
	self._index = math.max(math.floor(position), 0)
end

function Flux.ResetCursor(self: FluxInternal)
	self._index = 0
end

function Flux.WriteInt(self: FluxInternal, width: number, value: number)
	
	if value % 1 ~= 0 then
		error(`[{script.Name}]: Attempt to write non-integer value with Flux:WriteInt()`, 2)
	end
	
	local sign = 0
	
	if value < 0 then
		
		sign = 1
		value = -value
		
	end
	
	self:WriteBits(1, sign)
	self:WriteBits(width - 1, value)
	
end

function Flux.WriteUInt(self: FluxInternal, width: number, value: number)
	
	if value % 1 ~= 0 then
		error(`[{script.Name}]: Attempt to write non-integer value with Flux:WriteUInt()`, 2)
	end
	
	if value < 0 then
		error(`[{script.Name}]: Attempt to write signed integer value with Flux:WriteUInt()`, 2)
	end
	
	self:WriteBits(width, value)
	
end

function Flux.ReadInt(self: FluxInternal, width: number): number
	
	local sign = self:ReadBits(1) == 0 and 1 or -1
	
	return sign * self:ReadBits(width - 1)
	
end

function Flux.ReadUInt(self: FluxInternal, width: number): number
	return self:ReadBits(width)
end

function Flux.WriteBits(self: FluxInternal, width: number, value: number)
	
	buffer.writebits(self._buffer, self._index, width, value)
	self:SetCursor(self._index + width)
	
end

function Flux.ReadBits(self: FluxInternal, width: number): number
	
	local index = self._index
	self:SetCursor(self._index + width)
	
	return buffer.readbits(self._buffer, index, width)
	
end

function Flux.WriteBool(self: FluxInternal, value: boolean)
	
	if value == true then
		self:WriteBits(1, 1)
	else
		self:WriteBits(1, 0)
	end
	
end

function Flux.ReadBool(self: FluxInternal): boolean
	return self:ReadBits(1) == 1 and true or false
end

function Flux.WriteMantissa(self: FluxInternal, width: number, value: number)
	
	if value > 1 or value < 0 then
		error(`[{script.Name}]: Attempt to write manttisa value outside of [0, 1] range! Value: {value}`, 2)
	end
	
	for i = 1, width do
		
		value *= 2
		
		local bitValue = value >= 1 and 1 or 0
		self:WriteBits(1, bitValue)
		
		if bitValue == 1 then
			value -= 1
		end
		
	end
	
end

function Flux.ReadMantissa(self: FluxInternal, width: number): number
	
	local value = 0
	
	for i = 1, width do
		
		local bitValue = self:ReadBits(1)
		value += bitValue * (1 / PowerOfTwo[i])
		
	end
	
	return value
	
end

function Flux.ReadUFloat(self: FluxInternal, mantissaBitWidth: number, exponentBitWidth: number): number

	local exponent = self:ReadBits(exponentBitWidth)
	local mantissa = self:ReadBits(mantissaBitWidth)

	exponent = exponent - (PowerOfTwo[exponentBitWidth - 1] - 1) - 1

	if exponent == 0 and mantissa == 0 then
		return 0
	end

	mantissa = mantissa / PowerOfTwo[mantissaBitWidth] / 2 + 0.5
	return math.ldexp(mantissa, exponent)

end

function Flux.WriteUFloat(self: FluxInternal, mantissaBitWidth: number, exponentBitWidth: number, value: number)
	
	if value < 0 then
		error(`[{script.Name}]: Attempt to write signed value with Flux:WriteUFloat()`, 2)
	end

	local mantissa, exponent = math.frexp(value)

	if mantissa == 0 and exponent == 0 then
		self:WriteBits(mantissaBitWidth + exponentBitWidth + 1, 0)

		return
	end

	mantissa = (mantissa - 0.5) / 0.5 * PowerOfTwo[mantissaBitWidth]

	mantissa = mantissa + 0.5
	mantissa = mantissa - mantissa % 1 

	exponent = exponent + (PowerOfTwo[exponentBitWidth - 1] - 1) - 1

	self:WriteBits(exponentBitWidth, exponent)
	self:WriteBits(mantissaBitWidth, mantissa)

end

function Flux.ReadUFloat16(self: FluxInternal): number
	self:ReadFloat(10, 6)
end

function Flux.ReadUFloat32(self: FluxInternal): number
	return self:ReadFloat(24, 8)
end

function Flux.WriteUFloat16(self: FluxInternal, value: number)
	self:WriteFloat(10, 6, value)
end

function Flux.WriteUFloat32(self: FluxInternal, value: number)
	self:WriteFloat(24, 8, value)
end

function Flux.ReadFloat(self: FluxInternal, mantissaBitWidth: number, exponentBitWidth: number): number
	
	local sign = self:ReadBits(1) == 0 and 1 or -1
	local exponent = self:ReadBits(exponentBitWidth)
	local mantissa = self:ReadBits(mantissaBitWidth)
	
	exponent = exponent - (PowerOfTwo[exponentBitWidth - 1] - 1) + 1
	
	if exponent == 0 and mantissa == 0 then
		return 0
	end
	
	mantissa = mantissa / PowerOfTwo[mantissaBitWidth] / 2 + 0.5
	
	return sign * math.ldexp(mantissa, exponent)
	
end

function Flux.WriteFloat(self: FluxInternal, mantissaBitWidth: number, exponentBitWidth: number, value: number)

	local signBit = 0
	
	if value < 0 then
		
		signBit = 1
		value = -value
		
	end
	
	local mantissa, exponent = math.frexp(value)
	
	if mantissa == 0 and exponent == 0 then
		self:WriteBits(mantissaBitWidth + exponentBitWidth + 1, 0)
		
		return
	end
	
	mantissa = (mantissa - 0.5) / 0.5 * PowerOfTwo[mantissaBitWidth]
	
	self:WriteBits(1, signBit)
	
	mantissa = mantissa + 0.5
	mantissa = mantissa - mantissa % 1 
	
	exponent = exponent + (PowerOfTwo[exponentBitWidth - 1] - 1) - 1
	
	self:WriteBits(exponentBitWidth, exponent)
	self:WriteBits(mantissaBitWidth, mantissa)

end

function Flux.ReadFloat16(self: FluxInternal): number
	return self:ReadFloat(10, 5)
end

function Flux.ReadFloat32(self: FluxInternal): number
	return self:ReadFloat(23, 8)
end

function Flux.WriteFloat16(self: FluxInternal, value: number)
	self:WriteFloat(10, 5, value)
end

function Flux.WriteFloat32(self: FluxInternal, value: number)
	self:WriteFloat(23, 8, value)
end

-- // Constructors

function Flux.fromBuffer(value: buffer): Flux
	
	local newFlux = {
		_buffer = value,
		_index = 0,
	}
	
	return setmetatable(newFlux, Flux)
	
end

function Flux.new(sizeInBytes: number): Flux
	
	local newFlux = {
		_buffer = buffer.create(sizeInBytes),
		_index = 0,
	}
	
	return setmetatable(newFlux, Flux)
	
end

return Flux

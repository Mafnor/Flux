# Mafnor - Flux

Flux is a roblox buffer library wrapper that allows for easy writing to buffers and reading to buffers, mainly used for network serialization/deserialization.

I've made this module so I don't have to write massive pieces of code to for example write a Float16 value to a buffer, since the roblox library only supports Float32 values and Float64 values.

## How does this library work?

When creating a new flux object, you start out at the first bit index of the buffer from where you can start writing and reading to and from the buffer.
Whenever you read a value or write a value the bit index shifts by the offset, example being if you write a Float16 value to a flux, the bit index will be equal to 16.

You can change this index by changing the cursor position. You can find more about these methods in the Flux module.
I've also left some examples that are in the github repository that you can look at.

---

*Created by [Mafnor](https://x.com/Mafnor_)*

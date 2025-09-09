# Mafnor - Flux

Flux is a roblox buffer library wrapper that allows for easy writing to buffers and reading to buffers, mainly used for network serialization/deserialization.

I've made this module so I don't have to write massive pieces of code to for example write a Float16 value to a buffer, since the roblox library only supports Float32 values and Float64 values.

## How does this library work?

When you create a new flux object, it starts at the first bit index of the buffer—the point where reading from and writing to the buffer begins. Each read or write operation advances the bit index by the size of the value. For example, writing a Float16 value moves the bit index forward by 16 bits.

You can also manually adjust the index by changing the cursor position. More details on these methods can be found in the Flux module documentation. For practical reference, additional examples are available in the GitHub repository.

---

*Created by [Mafnor](https://x.com/Mafnor_)*

-- io/init.lua
-- I/O module aggregator

return {
    HDF5Data = require("falcon-core.io.hdf5data"),
    Time = require("falcon-core.io.time"),
    Loader = require("falcon-core.io.loader"),
}

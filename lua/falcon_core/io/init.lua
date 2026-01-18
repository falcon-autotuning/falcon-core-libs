-- io/init.lua
-- I/O module aggregator

return {
    HDF5Data = require("falcon_core.io.hdf5data"),
    Time = require("falcon_core.io.time"),
    Loader = require("falcon_core.io.loader"),
}

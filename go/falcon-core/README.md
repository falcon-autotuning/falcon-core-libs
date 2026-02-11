
To use this package on windwos make sure to set these in powerhsell first before building

$env:CGO_LDFLAGS="-LC:/Users/tyler/AppData/Local/falcon/lib -lfalcon_core_c_api -lfalcon_core_cpp"
$env:PKG_CONFIG_PATH="C:\Users\tyler\AppData\Local\falcon\lib\pkgconfig"
$env:CGO_CFLAGS="-IC:/Users/tyler/AppData/Local/falcon/include/falcon-core-c-api -IC:/Users/tyler/AppData/Local/falcon/include/falcon-core-cpp"

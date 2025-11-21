from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.loader import Loader as _CLoader
from falcon_core.physics.config.core.config import Config

class Loader:
    """Python wrapper for Loader."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def Loader_create(cls, config_path: str) -> Loader:
        return cls(_CLoader.Loader_create(config_path))

    def config(self, ) -> Config:
        ret = self._c.config()
        if ret is None: return None
        return Config._from_capi(ret)

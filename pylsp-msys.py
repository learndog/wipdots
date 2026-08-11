"""Run pylsp on Windows while accepting file URIs produced by MSYS Vim."""

import re
from urllib.parse import urlunparse

from pylsp import uris

_MSYS_DRIVE_PATH = re.compile(r"^/([a-zA-Z])(?:/|$)")
_original_to_fs_path = uris.to_fs_path


def _to_fs_path(uri):
    scheme, netloc, path, _params, _query, _fragment = uris.urlparse(uri)
    match = _MSYS_DRIVE_PATH.match(path)
    if scheme == "file" and not netloc and match:
        native_uri = urlunparse(
            (scheme, netloc, f"/{match.group(1)}:{path[2:]}", _params, _query, _fragment)
        )
        return _original_to_fs_path(native_uri)
    return _original_to_fs_path(uri)


uris.to_fs_path = _to_fs_path


if __name__ == "__main__":
    from pylsp.__main__ import main

    main()

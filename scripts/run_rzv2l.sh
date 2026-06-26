#!/bin/sh
set -eu

APP_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-eglfs}"
export QT_QUICK_BACKEND="${QT_QUICK_BACKEND:-opengl}"
export QSG_RENDER_LOOP="${QSG_RENDER_LOOP:-basic}"
export QT_LOGGING_RULES="${QT_LOGGING_RULES:-qt.scenegraph.general=true}"

exec "$APP_DIR/bin/QHUD" "$@"

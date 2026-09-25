if [ -e /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -e /usr/local/Homebrew/bin/brew ]; then
  eval "$(/usr/local/Homebrew/bin/brew shellenv)"
elif [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# image.nvim's magick_rock processor uses pkg-config and loads ImageMagick via FFI.
if [ "$(uname -s)" = Darwin ] && [ -n "${HOMEBREW_PREFIX:-}" ]; then
  imagemagick_prefix=
  for imagemagick_formula in imagemagick imagemagick-full imagemagick@6; do
    candidate="$HOMEBREW_PREFIX/opt/$imagemagick_formula"
    if [ -d "$candidate/lib" ]; then
      imagemagick_prefix="$candidate"
      break
    fi
  done

  if [ -n "$imagemagick_prefix" ]; then
    imagemagick_library_dir="$imagemagick_prefix/lib"
    imagemagick_pkgconfig_dir="$imagemagick_library_dir/pkgconfig"

    if [ -d "$imagemagick_pkgconfig_dir" ]; then
      case ":${PKG_CONFIG_PATH:-}:" in
        *":$imagemagick_pkgconfig_dir:"*) ;;
        *) export PKG_CONFIG_PATH="$imagemagick_pkgconfig_dir${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}" ;;
      esac
    fi

    case ":${DYLD_FALLBACK_LIBRARY_PATH:-}:" in
      *":$imagemagick_library_dir:"*) ;;
      *) export DYLD_FALLBACK_LIBRARY_PATH="$imagemagick_library_dir${DYLD_FALLBACK_LIBRARY_PATH:+:$DYLD_FALLBACK_LIBRARY_PATH}" ;;
    esac
  fi
fi

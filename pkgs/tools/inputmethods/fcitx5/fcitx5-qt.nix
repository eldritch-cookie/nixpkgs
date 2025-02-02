{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, qtbase
, qtwayland
, wrapQtAppsHook
, wayland
}:
let
  majorVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation rec {
  pname = "fcitx5-qt${majorVersion}";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-bVH2US/uEZGERslnAh/fyUbzR9fK1UfG4J+mOmrIE8Y=";
  };

  postPatch = ''
    substituteInPlace qt${majorVersion}/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT${majorVersion}PLUGINDIR}" $out/${qtbase.qtPluginPrefix}
  '';

  cmakeFlags = [
    "-DENABLE_QT4=OFF"
    "-DENABLE_QT5=OFF"
    "-DENABLE_QT6=OFF"
    "-DENABLE_QT${majorVersion}=ON"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwayland
    fcitx5
    wayland
  ];

  meta = with lib; {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with licenses; [ lgpl21Plus bsd3 ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}

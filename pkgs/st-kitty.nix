{
  fetchpatch,
  imlib2,
  lib,
  st,
  zlib,
}:
st.override {
  extraLibs = [imlib2 zlib];
  patches = [
    # Network access is unavailable in this environment, so this placeholder hash
    # must be replaced from the first rebuild failure output.
    (fetchpatch {
      url = "https://st.suckless.org/patches/kitty-graphics-protocol/st-kitty-graphics-20251230-0.9.3.diff";
      hash = lib.fakeHash;
    })
  ];
}

# Use local rb_sys gem (only needed for developing in this repo)
$LOAD_PATH.unshift(File.expand_path("../../../../gem/lib", __dir__))

# We need to require mkmf *first* this since `rake-compiler` injects code here for cross compilation
require "mkmf"
require "rb_sys/mkmf"

create_rust_makefile("rust_reverse/rust_reverse") do |r|
  # Create debug builds in dev. Make sure that release gems are compiled with
  # `RB_SYS_CARGO_PROFILE=release` (optional)
  r.profile = ENV.fetch("RB_SYS_CARGO_PROFILE", :dev).to_sym

  # Can be overridden with `RB_SYS_CARGO_FEATURES` env var (optional)
  r.features = ["test-feature"]

  # You can add whatever env vars you want to the env hash (optional)
  r.env = {"FOO" => "BAR"}

  # If your Cargo.toml is in a different directory, you can specify it here (optional)
  r.ext_dir = "."

  # Extra flags to pass to the $RUSTFLAGS environment variable (optional)
  r.extra_rustflags << "--cfg=some_nested_config_var_for_crate"

  # Force a rust toolchain to be installed via rustup (optional)
  # You can also set the env var `RB_SYS_FORCE_INSTALL_RUST_TOOLCHAIN=true`
  r.force_install_rust_toolchain = false

  # Extra args to pass to the `cargo rustc` command (optional)
  r.extra_cargo_args << "--quiet"

  # Extra args to pass to the `rustc` command (optional)
  r.extra_rustc_args = []

  # Extra targets to install via rustup (optional)
  r.extra_rustup_targets = ["wasm32-unknown-unknown"]

  # Enable stable API compiled fallback for ruby-head (optional)
  r.use_stable_api_compiled_fallback = true
end

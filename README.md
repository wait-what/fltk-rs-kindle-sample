# fltk-rs-kindle-sample
Sample program using Rust and FLTK for Kindle GUI development on jailbroken `kindlepw2` and `kindlehf`

> [!CAUTION]
> `kindlepw2` support is entirely untested

Sample running on Kindle | Sample running on desktop | Sample in FLUID
--- | --- | ---
![](./demo/kindle.png) | ![](./demo/desktop.png) | ![](./demo/fluid.png)

## Build
### Prerequisites
- Build tools for your platform (e.g. `build-essential`, `base-devel` etc.)
- [rust and cargo](https://rustup.rs/)
- Docker
- [cross-rs](https://github.com/cross-rs/cross)
```
cargo install cross --git https://github.com/cross-rs/cross
```

### For desktop
```sh
cargo run
```

### For Kindle
```sh
cross build --target armv7-unknown-linux-gnueabihf --release -vv
cp target/armv7-unknown-linux-gnueabihf/release/fltk-rs-kindle-sample sample_hf

cross build --target armv7-unknown-linux-gnueabi --release -vv
cp target/armv7-unknown-linux-gnueabi/release/fltk-rs-kindle-sample sample_sf
```

### Cleaning up
```sh
cargo clean
docker image prune -a # dangerous!!!
```

## Links
- fltk-rs documentation: [docs.rs/fltk](https://docs.rs/fltk/latest/fltk/)
- FLTK documentation: [fltk.org/doc-1.4](https://www.fltk.org/doc-1.4/index.html)
- More examples (though not necessarily for Kindle): [github.com/fltk-rs/fltk-rs#examples](https://github.com/fltk-rs/fltk-rs?tab=readme-ov-file#examples)
- Theming plugin: [crates.io/crates/fltk-theme](https://crates.io/crates/fltk-theme)
- Design GUIs interactively: [FLTK Rust: Latest FLUID, fl2rust and fltk-rs](https://youtu.be/33NdaW08fP8)
- Kindle Modding Wiki: [kindlemodding.org](https://kindlemodding.org/)

## License
[GPL-3.0](./LICENSE)

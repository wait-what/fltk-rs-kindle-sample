fn main() {
    println!("cargo:rerun-if-changed=src/ui.fl");

    cc::Build::new()
        .file("src/getauxval_stub.c")
        .compile("getauxval_stub");
}

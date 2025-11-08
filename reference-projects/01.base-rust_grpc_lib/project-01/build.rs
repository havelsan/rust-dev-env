fn main() -> Result<(), Box<dyn std::error::Error>> {
    //tonic_prost_build::configure().out_dir("src/helloworld/interface").compile_protos("./src/proto/helloworld.proto")?;
    //tonic_prost_build::configure().out_dir("src/").build_server(false).build_client(false).compile_protos(&["./src/proto/helloworld.proto"],&[""])?;
    tonic_prost_build::configure().out_dir("src/").compile_protos(&["./src/proto/helloworld.proto"],&[""])?;


    Ok(())
}

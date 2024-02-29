import './libv86.js'
function elem(id){
    return document.getElementById(id);
}
onload = (ev)=>{
    /**
     * @type {import('./libv86.js).V86Starter}
     */
    var starter =  new V86Starter({
        wasm_path: "./v86.wasm",
        vga_memory_size: 2 * 1024 * 1024,
        memory_size: 512 * 1024 * 1024,
        screen_container: elem("screen"),
        autostart: true,
        bios: {
            url:  "./seabios.bin",

        },
        vga_bios: {
            url: "./vgabios.bin"
        },
        bzimage: {
            url: "./bzImage"
        },
        initrd: {
            url: "./initramfs-virt"
        },
        hda: {
            url: "./alpine.img"
        },
        network_relay_url: "wss://relay.widgetry.org/"
    });;
    
    
}
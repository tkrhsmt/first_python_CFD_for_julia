
function visu_arr(contents)
    show(IOContext(stdout, :compact => false), "text/plain", contents)
    println("")
end

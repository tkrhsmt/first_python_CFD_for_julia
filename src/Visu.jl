
function arr_print(contents)
    show(IOContext(stdout, :compact => false), "text/plain", contents)
    println("")
end

namespace VoodooWarez.Systems.Input.Test

import System
import System.IO

import VoodooWarez.Systems.Input
import VoodooWarez.Systems.Import


# file
file = argv[0]
fd= File.Open(file,FileMode.Open)

raise ArgumentException("Invalid file") if not fd

# run name io ctl on file
name_ioc = NameIoCtl()
b = StringBufferK()
run = name_ioc.DoIoCtl(fd.Handle.ToInt32(),b)
print "err:", run if run
print "val:", b.Value

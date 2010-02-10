namespace VoodooWarez.Systems.Input.Test

import System
import System.IO

import VoodooWarez.Systems.Input
import VoodooWarez.Systems.Import.Helper


id = InputDevice(argv[0])

b= StringBufferK()
rv = id.DoNameIoCtl(b)
print "${b.Value} [ ${rv} ]"

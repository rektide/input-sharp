namespace VoodooWarez.Systems.Input.Test

import System
import System.IO
import System.Threading

import VoodooWarez.Systems.Input
import VoodooWarez.Systems.Import.Helper


print "starting"

def ReadEvent(sender,ie as InputEvent):
	print "Event! ${ie.Code} ${ie.Value} ${ie.Type} ${ie.Time.TvSec} ${ie.Time.TvUsec}"

id = InputDevice(argv[0])
id.OnInputEvent += ReadEvent
id.IsReadingInputEvents = true

Thread.Sleep(8000)

namespace VoodooWarez.Systems.Input.Test

import System
import System.IO
import System.Threading

import VoodooWarez.Systems.Input
import VoodooWarez.Systems.Import.Helper


def ReadEvent(sender,ie as InputEvent):
	print "Event! ${ie.Code} ${ie.Value} ${ie.Type} ${ie.Time.TvSec} ${ie.Time.TvUsec}"

raise ArgumentException("No input device specified.") if not argv.Length

id = InputDevice(argv[0])
id.OnInputEvent += ReadEvent
id.IsReadingInputEvents = true
print "async reading begins now"

Thread.Sleep(8000)

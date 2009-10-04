namespace VoodooWarez.Systems.Input

import System
import System.Runtime.InteropServices

import VoodooWarez.ExCathedra.Convert.Bytes
import VoodooWarez.Systems.Import



# data structures for ioctl's

[StructLayout(LayoutKind.Sequential)]
struct DualInt:
	first as int
	second as int



# base Input IoCtl

abstract class BaseInputIoCtl[of T] ( IoCtl[of T] ):
	
	def constructor():
		Type = "E".GetAsciiBytes()[0]
		AccessMode = IocAccessMode.Read


abstract class BaseBufferedIoCtl ( BaseInputIoCtl[of BufferK] ):
	pass

abstract class BaseStringIoCtl ( BaseInputIoCtl[of StringBufferK] ) :
	pass
		



# IoCtl implementations

class VersionIoCtl ( BaseInputIoCtl[of int]) :

	def constructor():
		super()
		Command = 0x01

class IdIoCtl ( BaseInputIoCtl[of InputId] ):

	def constructor():
		super()
		Command = 0x02

class RepIoCtl ( BaseInputIoCtl[of DualInt] ):
	
	def constructor():
		super()
		Command = 0x03
		AccessMode = IocAccessMode.RW

class KeycodeIoCtl ( BaseInputIoCtl[of DualInt] ):
	
	def constructor():
		super()
		Command = 0x04
		AccessMode = IocAccessMode.RW

class NameIoCtl ( BaseStringIoCtl ):
	
	def constructor():
		super()
		Command = 0x06

class PhysIoCtl ( BaseStringIoCtl ):
	
	def constructor():
		super()
		Command = 0x07

class UniqIoCtl ( BaseStringIoCtl ):
	
	def constructor():
		super()
		Command = 0x08

class KeyIoCtl ( BaseBufferedIoCtl ):
	
	def constructor():
		super()
		Command = 0x18

class LedIoCtl ( BaseBufferedIoCtl ):
	
	def constructor():
		super()
		Command = 0x19


class SndIoCtl ( BaseBufferedIoCtl ):
	
	def constructor():
		super()
		Command = 0x1a


class SwIoCtl ( BaseBufferedIoCtl ):
	
	def constructor():
		super()
		Command = 0x1b

class BitIoCtl ( BaseBufferedIoCtl ):
	
	def constructor(bit as int):
		super()
		Command = 0x20 + bit

class AbsIoCtl ( BaseInputIoCtl[of InputAbsinfo] ):
	
	def constructor(abs as int):
		super()
		Command = 0x40 + abs
		WriteCommand = 0xc0 + abs
		AccessMode = IocAccessMode.RW

# TODO: Must handle the union in the ff_effect structure!
#class SffIoCtl ( BaseInputIoCtl[of FfEffect] ):
#	
#	def constructor():
#		super()
#		Command = 0x80
#		AccessMode = IocAccessMode.Write

class RmffIoCtl ( BaseInputIoCtl[of Int32] ):
	
	def constructor():
		super()
		Command = 0x81
		AccessMode = IocAccessMode.Write

class EffectsIoCtl ( BaseInputIoCtl[of Int32] ):
	
	def constructor():
		super()
		Command = 0x84

class GrabIoCtl ( BaseInputIoCtl[of Int32] ):
	
	def constructor():
		super()
		Command = 0x90
		AccessMode = IocAccessMode.Write


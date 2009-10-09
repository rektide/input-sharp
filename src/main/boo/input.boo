namespace VoodooWarez.Systems.Input

import System
import System.IO
import System.Runtime.InteropServices

import VoodooWarez.ExCathedra.Convert.Bytes
import VoodooWarez.Systems.Import



# data structures for ioctl's

[StructLayout(LayoutKind.Sequential)]
struct DualInt:
	first as int
	second as int



# base Input IoCtl

abstract class BaseInputIoCtl[of T(constructor)] ( IoCtl[of T], IDisposable ):
	
	file as FileStream
	handle as int

	Handle as int:
		get:
			return handle
		set:
			handle = value

	public def constructor():
		Type = "E".GetAsciiBytes()[0]
		AccessMode = IocAccessMode.Read
		handle = -1
	
	public def constructor(handle as int):
		self.handle = handle

	public def constructor(fileStream as FileStream):
		self.file = fileStream
		self(fileStream.Handle.ToInt32())
		
	def constructor(fileName as string):
		self.file = File.Open(fileName, FileMode.Open, FileAccess.Read)
		self(file.Handle.ToInt32())

	def CreateIoCtlBuffer() as T:
		# boo has not yet implemented
		# return T()
		return Activator.CreateInstance[of T]()
		
	def DoIoCtl(ref obj as T) as int:
		raise Exception("Invalid handle ${Handle}") if self.Handle < 0
		return DoIoCtl(self.Handle, obj)
	
	def Dispose():
		file.Close() if file
	
	
abstract class BaseBufferedIoCtl ( BaseInputIoCtl[of BufferTFS] ):
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


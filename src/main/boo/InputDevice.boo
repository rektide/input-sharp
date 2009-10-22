namespace VoodooWarez.Systems.Input

import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler.MetaProgramming

import System
import System.IO
import System.Text

import VoodooWarez.Systems.Import



macro YieldClass: 
	className = YieldClass.Arguments[0] as ReferenceExpression
	genericName = YieldClass.Arguments[1] as ReferenceExpression
	print "starting arguments; emitting your stuff ${className.Name} ${genericName.Name}"
	yield [|
		# here comes the IoCollection magic to initialize static instance
		static $('_'+className.Name) as $(className.Name) = IoCtl.Instance[typeof( $(className.Name) )] as $(className.Name) 
	|]
	yield [|
		# public static instance
		static $(className.Name) as $(className.Name):
			get:
				return $(ReferenceExpression('_'+className.Name))
				
	|]
	yield [|
		# run
		def $('Do'+className.Name) (ref i as $(genericName.Name) ):
			return $(ReferenceExpression('_'+className.Name)).DoIoCtl (self.Handle,i)
		
	|]
	


class InputDevice ( ):
	
	handle as int	
	file as string
	fd as FileStream
	
	Handle as int:
		get:
			return handle if handle > 0
			return fd.Handle.ToInt32() if fd
			raise ArgumentException("No File Handle")
	
	def constructor(deviceFilename as string):
		file = deviceFilename
		fd = File.Open(file, FileMode.Open, FileAccess.Read)
		handle = fd.Handle.ToInt32() if fd
	
	def constructor(fileHandle as int):
		handle = fileHandle

	
		
	# YieldMacro template, implementing VersionIoCtl
	static _VersionIoCtl as VersionIoCtl
	
	static VersionIoCtl as VersionIoCtl:
		get:
			return IoCtl.Instance[typeof(VersionIoCtl)] as VersionIoCtl
	
	def RunVersionIoCtl(ref i as int) as int:
		_VersionIoCtl = VersionIoCtl if not _VersionIoCtl
		return _VersionIoCtl.DoIoCtl(self.Handle, i)
	
	# macros
	YieldClass  IdIoCtl,  InputId 
	YieldClass  RepIoCtl,  DualInt
	YieldClass  KeycodeIoCtl,  DualInt
	YieldClass  NameIoCtl,  StringBufferK
	YieldClass  UniqIoCtl,  StringBufferK
	YieldClass  KeyIoCtl,  BufferTFS
	YieldClass  LedIoCtl,  BufferTFS 
	YieldClass  SndIoCtl,  BufferTFS
	YieldClass  SwIoCtl,  BufferTFS
	YieldClass  BitIoCtl,  BufferTFS
	YieldClass  AbsIoCtl,  InputAbsinfo
	YieldClass  RmffIoCtl,  Int32
	YieldClass  EffectsIoCtl,  Int32
	YieldClass  GrabIoCtl,  Int32
	

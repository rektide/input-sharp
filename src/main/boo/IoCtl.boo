namespace VoodooWarez.Systems.Input

import System
import System.Runtime.InteropServices

import VoodooWarez.ExCathedra.ClassGen

[Flags]
public enum IocAccessMode:
	None = 0
	Write = 1
	Read = 2
	RW = 3

struct IoCtlStruct:
	[FieldOffset(0)] [Property(Command)] command as byte
	[FieldOffset(1)] [Property(Type)] type as byte
	[FieldOffset(2)] [Property(Size)] size as ushort
	
	FullCommand as ushort:
		get:
			return type << 8 | command
		set:
			command = value & 0xFF
			type = value >> 8
	
	AccessMode as IocAccessMode:
		get:
			return Enum.ToObject(IocAccessMode,size >> 14)
		set:
			size = size & 0x3FFF | cast(ushort,value) << 14

	ParameterSize as ushort:
		get:
			return size & 0x3FFF
		set:	
			size = size & 0xC000 | value & 0x3FFF


[StructLayout(LayoutKind.Explicit, Size: 4)]
class IoCtl[of T]:
	
	# integral ioctl data structure structure
	underlying as IoCtlStruct
	
	ComposeProperties underlying, "", \
		Command as byte, Type as byte, \
		Size as ushort, FullCommand as ushort, \
		AccessMode as IocAccessMode, ParameterSize as ushort
	
	# IoCtl's may be read or write but not both at once:
	[Property(SingleAccess)] singleAccess = false
	# read/write may have different commands
	[Property(WriteCommand)] writeCommand as byte = 0

	[DllImport("libc.so", EntryPoint: "ioctl")] 
	protected static def IoCtlNone([In] fd as int, [In] command as int, [In] obj as T):
		pass
	
	[DllImport("libc.so", EntryPoint: "ioctl")] 
	protected static def IoCtlRead([In] fd as int, [In] command as int, [Out] obj as T):
		pass

	[DllImport("libc.so", EntryPoint: "ioctl")] 
	protected static def IoCtlWrite([In] fd as int, [In] command as int, [In] obj as T):
		pass
	
	[DllImport("libc.so", EntryPoint: "ioctl")] 
	protected static def IoCtlBoth([In] fd as int, command as int, [In,Out] obj as T):
		pass
	
	def constructor():
		pass
	
	def constructor(size as ushort):
		Size = size
	
	def constructor(command as byte, type as byte, accessMode as IocAccessMode):
		Size = 0
		try:
			Size = Marshal.SizeOf(T)
		except:
			pass
		self(command,type,Size,accessMode)

	def constructor(command as byte, type as byte, size as ushort, accessMode as IocAccessMode):
		Command = command
		Type = type
		Size = size
		AccessMode = accessMode
	
	def Run(handle as int, ref obj as T) as int:
		raise ArgumentException("Invalid handle") if handle < 1
		mode = AccessMode
		if mode == IocAccessMode.RW:
			if singleAccess == true:
				# default to ro
				IoCtlRead(handle, Command, obj)
			else:
				IoCtlBoth(handle, Command, obj)
		if mode == IocAccessMode.Read:
			IoCtlRead(handle, Command, obj)
		elif mode == IocAccessMode.Write:
			if writeCommand == 0:
				IoCtlWrite(handle, Command, obj)
			else:
				IoCtlWrite(handle, writeCommand, obj)
		elif mode == IocAccessMode.None:
			IoCtlNone(handle, Command, obj)
		else:
			raise ArgumentException("Invalid AccessMode")


namespace VoodooWarez.Systems.Input

import System
import System.Runtime.InteropServices

import VoodooWarez.ExCathedra.ClassGen
import VoodooWarez.ExCathedra.Collections
import VoodooWarez.ExCathedra.Functional

[Flags]
public enum IocAccessMode:
	None = 0
	Write = 1
	Read = 2
	RW = 3


[StructLayout(LayoutKind.Explicit, Size: 4)]
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


class IoCtlCollection:

	[Property(TypeMap)]
	static typeMap as MappedCollection[of Type,object]


class IoCtl[of T] (IoCtlCollection):
	
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

	#[DllImport("libc.so", EntryPoint: "ioctl")] 
	[DllImport("libc.so", EntryPoint: "ioctl", CallingConvention: CallingConvention.Cdecl)] 
	protected def IoCtlNone(fd as int, command as IoCtlStruct, [In] ref obj as T):
		pass
	
	#[DllImport("libc.so", EntryPoint: "ioctl")] 
	[DllImport("libc.so", EntryPoint: "ioctl", CallingConvention: CallingConvention.Cdecl)] 
	protected def IoCtlRead(fd as int, command as IoCtlStruct, [Out] ref obj as T):
		pass

	#[DllImport("libc.so", EntryPoint: "ioctl")] 
	[DllImport("libc.so", EntryPoint: "ioctl", CallingConvention: CallingConvention.Cdecl)] 
	protected def IoCtlWrite(fd as int, command as IoCtlStruct, [In] ref obj as T):
		pass
	
	#[DllImport("libc.so", EntryPoint: "ioctl")]
	[DllImport("libc.so", EntryPoint: "ioctl", CallingConvention: CallingConvention.Cdecl)] 
	protected def IoCtlBoth(fd as int, command as IoCtlStruct, [In,Out] ref obj as T):
		pass
	
	def constructor():
		Size = Marshal.SizeOf(T)
	
	def constructor(size as ushort):
		Size = size
	
	def constructor(command as byte, type as byte, accessMode as IocAccessMode):
		super()
		Size = 0
		self(command,type,Size,accessMode)

	def constructor(command as byte, type as byte, size as ushort, accessMode as IocAccessMode):
		Command = command
		Type = type
		Size = size
		AccessMode = accessMode
	
	def DoIoCtl(handle as int, ref obj as T ) as int:
		raise ArgumentException("Invalid handle") if handle < 1
		mode = AccessMode
		if mode == IocAccessMode.RW:
			if singleAccess == true:
				# default to ro
				IoCtlRead(handle, underlying, obj)
			else:
				IoCtlBoth(handle, underlying, obj)
		elif mode == IocAccessMode.Read:
			IoCtlRead(handle, underlying, obj)
		elif mode == IocAccessMode.Write:
			if writeCommand == 0:
				IoCtlWrite(handle, underlying, obj)
			else:
				buf = Command
				Command = writeCommand
				IoCtlWrite(handle, underlying, obj)
				Command = buf
		elif mode == IocAccessMode.None:
			IoCtlNone(handle, underlying, obj)
		else:
			raise ArgumentException("Invalid AccessMode")


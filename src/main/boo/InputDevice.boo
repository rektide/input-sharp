namespace VoodooWarez.Systems.Input

import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler.MetaProgramming

import System
import System.IO
import System.Text

import VoodooWarez.Systems.Import

#[Meta]
#def LookupType(type as ReferenceExpression) as Type:
#	return Type.GetType(type.Name)



macro IoCtlMacro:
	className = IoCtlMacro.Arguments[0] as ReferenceExpression
	type = IoCtlMacro.Arguments[1] as ReferenceExpression

	#v = [| $(VersionIoCtl) |]

	yield [|
		protected static $(className) = $(type)()
	|]
	yield [|
		def $(className) ( ref obj as $(type) ):
			return 
	|]


macro ComposeMethods:
	
	#mangler as ReferenceExpression, 
	#defaultMethod as ReferenceExpression, 
	#autoArgs as ArrayLiteralExpression, 
	#userArgs as ArrayLiteralExpression):
	
	print "Starting compose"
	for m in ComposeMethods.Body.Statements:
		print "Composing Method ${m}"
		className as string
		memberName = ComposeMethods.Arguments[1] as ReferenceExpression
		
		if mie = m as MethodInvocationExpression:
			target = mie.Target as ReferenceExpression
			methodName = target.Name
			memberTarget = target as MemberReferenceExpression
			className = memberTarget.Target.ToString() if memberTarget
		elif m as MacroStatement:
			className = (m as MacroStatement).Name
		else:
			print "ComposeMethod found an unknown body member [type:$m.GetType()]; skipping"
			continue
		
		method = Method()
		# todo: mangler
		manglefunc = def(className as string, memberName as string):
			return "Do${className}"
		
		# build invocation arguments
		#mangledName = manglefunc(className, memberName)
		mangledName as string
		method.Name = mangledName
		inv = StringBuilder("o.${memberName}(")
		autoArgs = ComposeMethods.Arguments[2] as ArrayLiteralExpression
		for i in autoArgs.Items:
			inv.Append(i)
			inv.Append(",")
		inv.Remove(inv.Length-1,1)
		
		# build method arguments & invocation arguments
		remainingArgs = ComposeMethods.Arguments[3] as ArrayLiteralExpression
		for i in remainingArgs.Items:
			tce = i as TryCastExpression
			raise InvalidCastException("Argument ${i} is not a TryCaseExpression")
			
			param = ParameterDeclaration(tce.Target.ToString(), tce.Type, ParameterModifiers.None)
			method.Parameters.Add(param)
			
			inv.Append(tce.Target)
			inv.Append(",")
		inv.Remove(inv.Length-1,1)
		
		#ret = ReturnStatement(inv.ToString())
		
		#method.Body.Expressions = [|
		
		mpc = method.Parameters
		#tmp = [|
		#	def $(mangledName) ( $(mpc) ) :
		#		o = System.Activator.CreateInstance[of $(className)]( $(args) )
		#		return $(className).$(methodName) ( $mpc )
		#|]
		#print tmp.GetType()
		#yield tmp
	print "Done with compose"

#
#ComposeMethods (VersionIoCtl, IdIoCtl, RepIoCtl):
#	className = "Do${className}"
#	yield [|
#		def $(className) ( ref obj as T ):
#			pass
#	|]

macro YieldClass: 
	print "in your macros"
	className = YieldClass.Arguments[0] as ReferenceExpression
	genericName = YieldClass.Arguments[1] as ReferenceExpression
	print "macro failing; lost arguments" if not className and not genericName
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
	#print '_'+className.Name+'.DoIoCtl(self.Handle,i)'
	yield [|
		# run
		def $('Do'+className.Name) (ref i as $(genericName.Name) ):
			return $(ReferenceExpression('_'+className.Name)).DoIoCtl (self.Handle,i)
		
	|]
	print "this macro is over"
	#yeild [|
	#|]
	


class InputDevice ( ):
	
	handle as int	
	file as string
	fd as FileStream
	
	# version template
	static _VersionIoCtl as VersionIoCtl
	
	static VersionIoCtl as VersionIoCtl:
		get:
			return IoCtl.Instance[typeof(VersionIoCtl)] as VersionIoCtl
	
	def RunVersionIoCtl(ref i as int) as int:
		_VersionIoCtl = VersionIoCtl if not _VersionIoCtl
		return _VersionIoCtl.DoIoCtl(self.Handle, i)
	
	# tepmlate helpers	
	[meta]
	def DoSomething(t as Type):
		pass
	
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
	
	#ComposeMethods ComposeNames, DoIoCtl, (Handle,), ("ref obj as T",):
	#	VersionIoCtl
	#	IdIoCtl
	#	RepIoCtl
	#	KeycodeIoCtl
	#	NameIoCtl

	#ComposeMethods ComposeNames(
	#
	#
	#[Meta]	
	#static def ComposeNames(className as string, memberName as string):
	#	return "Do${className}"

		

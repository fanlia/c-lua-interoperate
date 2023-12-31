[translated]
module main

type Off_t = Off64_t
type Fpos_t = Fpos64_t
fn fputs(__s Char *restrict, __stream FILE *restrict) int

fn fileno(__stream &C.FILE) int

struct Lldiv_t { 
	quot i64
	rem i64
}
fn getenv(__name &i8) &i8

fn raise(__sig int) int

fn sigemptyset(__set &Sigset_t) int

fn sigaction(__sig int, __act Sigaction *restrict, __oact Sigaction *restrict) int

type Lua_Number = f64
type Lua_Integer = i64
type Lua_Unsigned = i64
type Lua_KContext = C.intptr_t
type Lua_CFunction = fn (&Lua_State) int
type Lua_KFunction = fn (&Lua_State, int, Lua_KContext) int
type Lua_Reader = fn (&Lua_State, voidptr, &usize) &i8
type Lua_Writer = fn (&Lua_State, voidptr, usize, voidptr) int
type Lua_Alloc = fn (voidptr, voidptr, usize, usize) voidptr
type Lua_WarnFunction = fn (voidptr, &i8, int)
type Lua_Hook = fn (&Lua_State, &Lua_Debug)
fn lua_close(l &Lua_State) 

fn lua_gettop(l &Lua_State) int

fn lua_settop(l &Lua_State, idx int) 

fn lua_type(l &Lua_State, idx int) int

fn lua_toboolean(l &Lua_State, idx int) int

fn lua_tolstring(l &Lua_State, idx int, len &usize) &i8

fn lua_touserdata(l &Lua_State, idx int) voidptr

fn lua_pushinteger(l &Lua_State, n Lua_Integer) 

fn lua_pushlstring(l &Lua_State, s &i8, len usize) &i8

fn lua_pushstring(l &Lua_State, s &i8) &i8

[c2v_variadic]
fn lua_pushfstring(l &Lua_State, fmt &i8) &i8

fn lua_pushboolean(l &Lua_State, b int) 

fn lua_pushlightuserdata(l &Lua_State, p voidptr) 

fn lua_getglobal(l &Lua_State, name &i8) int

fn lua_rawget(l &Lua_State, idx int) int

fn lua_rawgeti(l &Lua_State, idx int, n Lua_Integer) int

fn lua_createtable(l &Lua_State, narr int, nrec int) 

fn lua_setglobal(l &Lua_State, name &i8) 

fn lua_setfield(l &Lua_State, idx int, k &i8) 

fn lua_rawset(l &Lua_State, idx int) 

fn lua_rawseti(l &Lua_State, idx int, n Lua_Integer) 

fn lua_warning(l &Lua_State, msg &i8, tocont int) 

[c2v_variadic]
fn lua_gc(l &Lua_State, what int) int

fn lua_concat(l &Lua_State, n int) 

fn lua_sethook(l &Lua_State, func Lua_Hook, mask int, count int) 

struct Lua_Debug { 
	event int
	name &i8
	namewhat &i8
	what &i8
	source &i8
	srclen usize
	currentline int
	linedefined int
	lastlinedefined int
	nups u8
	nparams u8
	isvararg i8
	istailcall i8
	ftransfer u16
	ntransfer u16
	short_src [60]i8
	i_ci &CallInfo
}
struct LuaL_Reg { 
	name &i8
	func Lua_CFunction
}
[c:'luaL_callmeta']
fn lual_callmeta(l &Lua_State, obj int, e &i8) int

[c:'luaL_tolstring']
fn lual_tolstring(l &Lua_State, idx int, len &usize) &i8

[c:'luaL_checkstack']
fn lual_checkstack(l &Lua_State, sz int, msg &i8) 

[c2v_variadic]
[c:'luaL_error']
fn lual_error(l &Lua_State, fmt &i8) int

[c:'luaL_newstate']
fn lual_newstate() &Lua_State

[c:'luaL_len']
fn lual_len(l &Lua_State, idx int) Lua_Integer

[c:'luaL_traceback']
fn lual_traceback(l &Lua_State, l1 &Lua_State, msg &i8, level int) 

struct LuaL_Buffer { 
	b &i8
	size usize
	n usize
	L &Lua_State
	init Union (unnamed union at src/lauxlib.h
}
struct LuaL_Stream { 
	f &C.FILE
	closef Lua_CFunction
}
[c:'luaL_openlibs']
fn lual_openlibs(l &Lua_State) 

/*!*/[weak] __global ( globalL  = &Lua_State ((voidptr(0)))
)

[export:'progname']
const (
progname   = c'lua'
)

fn lstop(l &Lua_State, ar &Lua_Debug)  {
	void(ar)
	lua_sethook(l, (voidptr(0)), 0, 0)
	lual_error(l, c'interrupted!')
}

fn laction(i int)  {
	flag := (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3)
	signal(i, (sighandler_t(0)))
	lua_sethook(globalL, lstop, flag, 1)
}

fn print_usage(badoption &i8)  {
	(C.fprintf(C.stderr, (c'%s: '), (progname)) , C.fflush(C.stderr))
	if badoption [1]  == `e` || badoption [1]  == `l` {
	(C.fprintf(C.stderr, (c"'%s' needs argument\n"), (badoption)) , C.fflush(C.stderr))
	}
	else { // 3
	(C.fprintf(C.stderr, (c"unrecognized option '%s'\n"), (badoption)) , C.fflush(C.stderr))
}
	(C.fprintf(C.stderr, (c"usage: %s [options] [script [args]]\nAvailable options are:\n  -e stat   execute string 'stat'\n  -i        enter interactive mode after executing 'script'\n  -l mod    require library 'mod' into global 'mod'\n  -l g=mod  require library 'mod' into global 'g'\n  -v        show version information\n  -E        ignore environment variables\n  -W        turn warnings on\n  --        stop handling options\n  -         stop handling options and execute stdin\n"), (progname)) , C.fflush(C.stderr))
}

fn l_message(pname &i8, msg &i8)  {
	if pname {
	(C.fprintf(C.stderr, (c'%s: '), (pname)) , C.fflush(C.stderr))
	}
	(C.fprintf(C.stderr, (c'%s\n'), (msg)) , C.fflush(C.stderr))
}

fn report(l &Lua_State, status int) int {
	if status != 0 {
		msg := lua_tolstring(l, (-1), (voidptr(0)))
		l_message(progname, msg)
		lua_settop(l, -(1) - 1)
	}
	return status
}

fn msghandler(l &Lua_State) int {
	msg := lua_tolstring(l, (1), (voidptr(0)))
	if msg == (voidptr(0)) {
		if lual_callmeta(l, 1, c'__tostring') && lua_type(l, -1) == 4 {
		return 1
		}
		else { // 3
		msg = lua_pushfstring(l, c'(error object is a %s value)', lua_typename(l, lua_type(l, (1))))
}
	}
	lual_traceback(l, l, msg, 1)
	return 1
}

fn docall(l &Lua_State, narg int, nres int) int {
	status := 0
	base := lua_gettop(l) - narg
	lua_pushcclosure(l, (msghandler), 0)
	lua_rotate(l, (base), 1)
	globalL = l
	signal(2, laction)
	status = lua_pcallk(l, (narg), (nres), (base), 0, (voidptr(0)))
	signal(2, (sighandler_t(0)))
	(lua_rotate(l, (base), -1) , lua_settop(l, -(1) - 1))
	return status
}

fn print_version()  {
	C.fwrite((c'Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio'), sizeof(i8), (C.strlen(c'Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio')), C.stdout)
	(C.fwrite((c'\n'), sizeof(i8), (1), C.stdout) , C.fflush(C.stdout))
}

fn createargtable(l &Lua_State, os.argv &&u8, argc int, script int)  {
	i := 0
	narg := 0
	
	narg = argc - (script + 1)
	lua_createtable(l, narg, script + 1)
	for i = 0 ; i < argc ; i ++ {
		lua_pushstring(l, os.argv [i] )
		lua_rawseti(l, -2, i - script)
	}
	lua_setglobal(l, c'arg')
}

fn dochunk(l &Lua_State, status int) int {
	if status == 0 {
	status = docall(l, 0, 0)
	}
	return report(l, status)
}

fn dofile(l &Lua_State, name &i8) int {
	return dochunk(l, lual_loadfilex(l, name, (voidptr(0))))
}

fn dostring(l &Lua_State, s &i8, name &i8) int {
	return dochunk(l, lual_loadbufferx(l, s, C.strlen(s), name, (voidptr(0))))
}

fn dolibrary(l &Lua_State, globname &i8) int {
	status := 0
	modname := C.strchr(globname, `=`)
	if modname == (voidptr(0)) {
	modname = globname
	}
	else {
		*modname = ` `
		modname ++
	}
	lua_getglobal(l, c'require')
	lua_pushstring(l, modname)
	status = docall(l, 1, 1)
	if status == 0 {
	lua_setglobal(l, globname)
	}
	return report(l, status)
}

fn pushargs(l &Lua_State) int {
	i := 0
	n := 0
	
	if lua_getglobal(l, c'arg') != 5 {
	lual_error(l, c"'arg' is not a table")
	}
	n = int(lual_len(l, -1))
	lual_checkstack(l, n + 3, c'too many arguments to script')
	for i = 1 ; i <= n ; i ++ {
	lua_rawgeti(l, -i, i)
	}
	(lua_rotate(l, (-i), -1) , lua_settop(l, -(1) - 1))
	return n
}

fn handle_script(l &Lua_State, os.argv &&u8) int {
	status := 0
	fname := os.argv [0] 
	if C.strcmp(fname, c'-') == 0 && C.strcmp(os.argv [-1] , c'--') != 0 {
	fname = (voidptr(0))
	}
	status = lual_loadfilex(l, fname, (voidptr(0)))
	if status == 0 {
		n := pushargs(l)
		status = docall(l, n, (-1))
	}
	return report(l, status)
}

fn collectargs(os.argv &&u8, first &int) int {
	args := 0
	i := 0
	if os.argv [0]  != (voidptr(0)) {
		if os.argv [0]  [0]  {
		progname = os.argv [0] 
		}
	}
	else {
		*first = -1
		return 0
	}
	for i = 1 ; os.argv [i]  != (voidptr(0)) ; i ++ {
		*first = i
		if os.argv [i]  [0]  != `-` {
		return args
		}
		match os.argv [i]  [1]  {
		 `-`// case comp body kind=IfStmt is_enum=true 
		{
		if os.argv [i]  [2]  != ` ` {
		return 1
		}
		*first = i + 1
		return args
		}
		 ` `// case comp body kind=ReturnStmt is_enum=true 
		{
		return args
		}
		 `E`// case comp body kind=IfStmt is_enum=true 
		{
		if os.argv [i]  [2]  != ` ` {
		return 1
		}
		args |= 16
		
		}
		 `W`// case comp body kind=IfStmt is_enum=true 
		{
		if os.argv [i]  [2]  != ` ` {
		return 1
		}
		
		}
		 `i`// case comp body kind=CompoundAssignOperator is_enum=true 
		{
		args |= 2
		}
		 `v`// case comp body kind=IfStmt is_enum=true 
		{
		if os.argv [i]  [2]  != ` ` {
		return 1
		}
		args |= 4
		
		}
		 `e`// case comp body kind=CompoundAssignOperator is_enum=true 
		{
		args |= 8
		}
		 `l`// case comp body kind=IfStmt is_enum=true 
		{
		if os.argv [i]  [2]  == ` ` {
			i ++
			if os.argv [i]  == (voidptr(0)) || os.argv [i]  [0]  == `-` {
			return 1
			}
		}
		
		}
		else {
		return 1
		}
		}
	}
	*first = 0
	return args
}

fn runargs(l &Lua_State, os.argv &&u8, n int) int {
	i := 0
	for i = 1 ; i < n ; i ++ {
		option := os.argv [i]  [1] 
		(void(0))
		match option {
		 `e`, `l`{
		{
			status := 0
			extra := os.argv [i]  + 2
			if *extra == ` ` {
			extra = os.argv [i ++$] 
			}
			(void(0))
			status = if (option == `e`){ dostring(l, extra, c'=(command line)') } else {dolibrary(l, extra)}
			if status != 0 {
			return 0
			}
			
		}
		}
		 `W`// case comp body kind=CallExpr is_enum=false 
		{
		lua_warning(l, c'@on', 0)
		
		}
		else{}
		}
	}
	return 1
}

fn handle_luainit(l &Lua_State) int {
	name := c'=LUA_INIT_5_4'
	init := getenv(name + 1)
	if init == (voidptr(0)) {
		name = c'=LUA_INIT'
		init = getenv(name + 1)
	}
	if init == (voidptr(0)) {
	return 0
	}
	else if init [0]  == `@` {
	return dofile(l, init + 1)
	}
	else {
	return dostring(l, init, name)
	}
}

fn get_prompt(l &Lua_State, firstline int) &i8 {
	if lua_getglobal(l, if firstline{ c'_PROMPT' } else {c'_PROMPT2'}) == 0 {
	return (if firstline{ c'> ' } else {c'>> '})
	}
	else {
		p := lual_tolstring(l, -1, (voidptr(0)))
		(lua_rotate(l, (-2), -1) , lua_settop(l, -(1) - 1))
		return p
	}
}

fn incomplete(l &Lua_State, status int) int {
	if status == 3 {
		lmsg := usize(0)
		msg := lua_tolstring(l, -1, &lmsg)
		if lmsg >= (sizeof(c'<eof>') / sizeof(i8) - 1) && C.strcmp(msg + lmsg - (sizeof(c'<eof>') / sizeof(i8) - 1), c'<eof>') == 0 {
			lua_settop(l, -(1) - 1)
			return 1
		}
	}
	return 0
}

fn pushline(l &Lua_State, firstline int) int {
	buffer := [512]i8{}
	b := buffer
	l := usize(0)
	prmt := get_prompt(l, firstline)
	readstatus := (void(l) , fputs(prmt, C.stdout) , C.fflush(C.stdout) , C.fgets(b, 512, C.stdin) != (voidptr(0)))
	if readstatus == 0 {
	return 0
	}
	lua_settop(l, -(1) - 1)
	l = C.strlen(b)
	if l > 0 && b [l - 1]  == `
` {
	b [l --$]  = ` `
	}
	if firstline && b [0]  == `=` {
	lua_pushfstring(l, c'return %s', b + 1)
	}
	else { // 3
	lua_pushlstring(l, b, l)
}
	{
		void(l)
		void(b)
	}
	0 /* null */
	return 1
}

fn addreturn(l &Lua_State) int {
	line := lua_tolstring(l, (-1), (voidptr(0)))
	retline := lua_pushfstring(l, c'return %s;', line)
	status := lual_loadbufferx(l, retline, C.strlen(retline), c'=stdin', (voidptr(0)))
	if status == 0 {
		(lua_rotate(l, (-2), -1) , lua_settop(l, -(1) - 1))
		if line [0]  != ` ` {
			void(l)
			void(line)
		}
		0 /* null */
	}
	else { // 3
	lua_settop(l, -(2) - 1)
}
	return status
}

fn multiline(l &Lua_State) int {
	for  ;  ;  {
		len := usize(0)
		line := lua_tolstring(l, 1, &len)
		status := lual_loadbufferx(l, line, len, c'=stdin', (voidptr(0)))
		if !incomplete(l, status) || !pushline(l, 0) {
			{
				void(l)
				void(line)
			}
			0 /* null */
			return status
		}
		lua_pushstring(l, c'\n')
		lua_rotate(l, (-2), 1)
		lua_concat(l, 3)
	}
}

fn loadline(l &Lua_State) int {
	status := 0
	lua_settop(l, 0)
	if !pushline(l, 1) {
	return -1
	}
	if (status = addreturn(l)) != 0 {
	status = multiline(l)
	}
	(lua_rotate(l, (1), -1) , lua_settop(l, -(1) - 1))
	(void(0))
	return status
}

fn l_print(l &Lua_State)  {
	n := lua_gettop(l)
	if n > 0 {
		lual_checkstack(l, 20, c'too many results to print')
		lua_getglobal(l, c'print')
		lua_rotate(l, (1), 1)
		if lua_pcallk(l, (n), (0), (0), 0, (voidptr(0))) != 0 {
		l_message(progname, lua_pushfstring(l, c"error calling 'print' (%s)", lua_tolstring(l, (-1), (voidptr(0)))))
		}
	}
}

[c:'doREPL']
fn dorepl(l &Lua_State)  {
	status := 0
	oldprogname := progname
	progname = (voidptr(0))
	(void(l))
	for (status = loadline(l)) != -1 {
		if status == 0 {
		status = docall(l, 0, (-1))
		}
		if status == 0 {
		l_print(l)
		}
		else { // 3
		report(l, status)
}
	}
	lua_settop(l, 0)
	(C.fwrite((c'\n'), sizeof(i8), (1), C.stdout) , C.fflush(C.stdout))
	progname = oldprogname
}

fn pmain(l &Lua_State) int {
	argc := int(lua_tointegerx(l, (1), (voidptr(0))))
	os.argv := &&u8(lua_touserdata(l, 2))
	script := 0
	args := collectargs(os.argv, &script)
	optlim := if (script > 0){ script } else {argc}
	lual_checkversion_(l, 504, (sizeof(Lua_Integer) * 16 + sizeof(Lua_Number)))
	if args == 1 {
		print_usage(os.argv [script] )
		return 0
	}
	if args & 4 {
	print_version()
	}
	if args & 16 {
		lua_pushboolean(l, 1)
		lua_setfield(l, (-1000000 - 1000), c'LUA_NOENV')
	}
	lual_openlibs(l)
	createargtable(l, os.argv, argc, script)
	lua_gc(l, 1)
	lua_gc(l, 10, 0, 0)
	if !(args & 16) {
		if handle_luainit(l) != 0 {
		return 0
		}
	}
	if !runargs(l, os.argv, optlim) {
	return 0
	}
	if script > 0 {
		if handle_script(l, os.argv + script) != 0 {
		return 0
		}
	}
	if args & 2 {
	dorepl(l)
	}
	else if script < 1 && !(args & (8 | 4)) {
		if 1 {
			print_version()
			dorepl(l)
		}
		else { // 3
		dofile(l, (voidptr(0)))
}
	}
	lua_pushboolean(l, 1)
	return 1
}

fn main()  {
	status := 0
	result := 0
	
	l := lual_newstate()
	if l == (voidptr(0)) {
		l_message(os.argv [0] , c'cannot create state: not enough memory')
		return 
	}
	lua_gc(l, 0)
	lua_pushcclosure(l, (&pmain), 0)
	lua_pushinteger(l, argc)
	lua_pushlightuserdata(l, os.argv)
	status = lua_pcallk(l, (2), (1), (0), 0, (voidptr(0)))
	result = lua_toboolean(l, -1)
	report(l, status)
	lua_close(l)
	return 
}


local watermark = "---------INSERT-IMPORTS---------"

-- Helper functions
-- Corrected split function
local function split(str, delim)
	local result = {}
	if delim == "" then
		return { str }
	end

	-- Handle multi-character delimiters
	local pos = 1
	local startPos, endPos = str:find(delim, pos, true)

	while startPos do
		table.insert(result, str:sub(pos, startPos - 1))
		pos = endPos + 1
		startPos, endPos = str:find(delim, pos, true)
	end

	-- Add the last part
	table.insert(result, str:sub(pos))

	return result
end

local function cutPrefix(str, prefix)
	if str:sub(1, #prefix) == prefix then
		return str:sub(#prefix + 1), true
	else
		return str, false
	end
end

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function replace_all(str, find, repl)
	return (str:gsub(find:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1"), repl))
end

local function join(tbl, delim)
	return table.concat(tbl, delim)
end

local function read_lines(path)
	local lines = {}
	local f = assert(io.open(path, "r"))
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()
	return lines
end

local function write_lines(path, lines)
	local f = assert(io.open(path, "w"))
	for _, line in ipairs(lines) do
		f:write(line .. "\n")
	end
	f:close()
end

local function panic(msg)
	io.stderr:write(msg .. "\n")
	os.exit(1)
end

local function contains(str, substr)
	return str:find(substr, 1, true) ~= nil
end

local function hasPrefix(str, prefix)
	return str:sub(1, #prefix) == prefix
end

local function hasSuffix(str, suffix)
	return str:sub(-#suffix) == suffix
end

local function trimPrefix(str, prefix)
	if hasPrefix(str, prefix) then
		return str:sub(#prefix + 1)
	end
	return str
end

local function trimSuffix(str, suffix)
	if hasSuffix(str, suffix) then
		return str:sub(1, -#suffix - 1)
	end
	return str
end

local function title(str)
	return str:sub(1, 1):upper() .. str:sub(2):lower()
end

-- Go import path finder
function findGoImport(headerPath, extraImport)
	local f = io.open(headerPath, "r")
	if not f then
		return nil
	end
	local search = "/" .. extraImport .. "_c_api.h"
	local includes = {}
	for line in f:lines() do
		repeat -- Using repeat-until as a continue block
			line = trim(line)
			if not hasPrefix(line, "#include") then
				break -- Continue to next iteration
			end
			local start_pos = line:find('"')
			local end_pos = line:find('"[^"]*$')
			if not start_pos or not end_pos or end_pos <= start_pos then
				break -- Continue to next iteration
			end
			local includePath = line:sub(start_pos + 1, end_pos - 1)
			if contains(line, search) then
				local parts = split(includePath, "falcon_core/")
				if #parts < 2 then
					break -- Continue to next iteration
				end
				local relPath = parts[2]
				relPath = replace_all(relPath, "_c_api.h", "")
				local segments = split(relPath, "/")
				segments[#segments] = segments[#segments]:lower()
				for i, seg in ipairs(segments) do
					segments[i] = replace_all(seg, "_", "-")
				end
				local goImport = "github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/" .. join(segments, "/")
				f:close()
				return goImport
			end
			if contains(includePath, "falcon_core/") then
				table.insert(includes, includePath)
			end
		until true -- End of repeat-until block
	end
	f:close()

	-- Recursive search in included headers
	for _, inc in ipairs(includes) do
		repeat -- Using repeat-until as a continue block
			local parts = split(headerPath, "falcon_core/")
			if #parts < 2 then
				break -- Continue to next iteration
			end
			local recursivePath = parts[1] .. inc
			local goImport = findGoImport(recursivePath, extraImport)
			if goImport then
				return goImport
			end
		until true -- End of repeat-until block
	end
	return nil
end

function insertImports(goFilePath, imports)
	local lines = read_lines(goFilePath)
	local out = {}
	for _, line in ipairs(lines) do
		if not contains(line, watermark) then
			table.insert(out, line)
		else
			if #imports == 0 then
				table.insert(out, "	// no extra imports")
			else
				for _, imp in ipairs(imports) do
					table.insert(out, string.format('	"%s"', imp))
				end
			end
		end
	end
	write_lines(goFilePath, out)
end

function IsPrimitive(gotype)
	local primitives = {
		["bool"] = true,
		["float64"] = true,
		["float32"] = true,
		["int32"] = true,
		["uint64"] = true,
		["*bool"] = true,
		["*float64"] = true,
		["*float32"] = true,
		["*int32"] = true,
		["*uint64"] = true,
		["int64"] = true,
		["int8"] = true,
	}
	return primitives[gotype] or false
end

function IsString(gotype)
	return gotype == "string" or gotype == "*string"
end

function IsNonPrimitive(gotype)
	return not IsPrimitive(gotype) and gotype ~= ""
end

function IsExtraImport(gotype)
	return IsNonPrimitive(gotype) and not IsString(gotype) and gotype ~= "*Handle" and gotype ~= "*string.Handle"
end

function uniqueStrings(input)
	local seen, result = {}, {}
	for _, str in ipairs(input) do
		if not seen[str] then
			seen[str] = true
			table.insert(result, str)
		end
	end
	return result
end

function CtoGType(ctype, packagetype)
	local map = {
		["void"] = "",
		["StringHandle"] = "string",
		["StringHandle*"] = "*string",
		["bool"] = "bool",
		["long long"] = "int64",
		["int8_t"] = "int8",
		["bool*"] = "*bool",
		["double"] = "float64",
		["double*"] = "*float64",
		["float"] = "float32",
		["float*"] = "*float32",
		["int"] = "int32",
		["int*"] = "*int32",
		["size_t"] = "uint64",
		["size_t*"] = "*uint64",
	}
	if map[ctype] then
		return map[ctype]
	end
	local packageType = extractCPrefix(ctype):lower()
	if packagetype == packageType then
		return "*Handle"
	end
	return "*" .. packageType .. ".Handle"
end

function extractCPrefix(ctype)
	ctype = replace_all(ctype, "*", "")
	ctype = replace_all(ctype, "Handle", "")
	return trim(ctype)
end

function extractGoPrefix(s)
	local parts = split(s, ".")
	local prefix = trim(parts[1])
	prefix = trimPrefix(prefix, "*")
	prefix = trimSuffix(prefix, "*")
	if prefix ~= "" then
		return prefix
	end
	return ""
end

function flattenGoParameters(p)
	local out = {}
	for i, pair in ipairs(p) do
		table.insert(out, pair.Name .. " " .. pair.Gotype)
	end
	return table.concat(out, ", ")
end

function countParams(funcLine)
	local params = {}
	local start_pos = funcLine:find("%(")
	local end_pos = funcLine:find("%)")
	if start_pos and end_pos and end_pos > start_pos + 1 then
		local paramStr = trim(funcLine:sub(start_pos + 1, end_pos - 1))
		if paramStr ~= "" then
			local rawParams = split(paramStr, ",")
			for _, p in ipairs(rawParams) do
				table.insert(params, NewCParameterPair(trim(p)))
			end
		end
	end
	return #params, params
end

function NewCParameterPair(paramStr)
	local splits
	if contains(paramStr, "const ") then
		local constSplits = {}
		local count = 0
		for s in paramStr:gmatch("%S+") do
			count = count + 1
			constSplits[count] = s
			if count == 3 then
				break
			end
		end
		splits = { constSplits[2], constSplits[3] }
	elseif contains(paramStr, "long long") then
		local fields = {}
		for s in paramStr:gmatch("%S+") do
			table.insert(fields, s)
		end
		local other = {}
		for i = 3, #fields do
			table.insert(other, fields[i])
		end
		splits = { "long long", join(other, " ") }
	else
		splits = {}
		for s in paramStr:gmatch("%S+") do
			table.insert(splits, s)
		end
		if #splits >= 2 then
			splits = { splits[1], join({ table.unpack(splits, 2) }, " ") }
		end
	end
	local name = splits[2] or ""
	local start_pos = name:find("%[")
	local end_pos = name:find("%]")
	if start_pos and end_pos and end_pos > start_pos then
		name = name:sub(1, start_pos - 1) .. name:sub(end_pos + 1)
	end
	return { Ctype = trim(splits[1] or ""), Name = trim(name) }
end

function NewGoParameterPair(pair, packagetype)
	return { Gotype = CtoGType(pair.Ctype, packagetype), Name = pair.Name }
end

function toGoParams(params, packagetype)
	local out = {}
	for _, pair in ipairs(params) do
		table.insert(out, NewGoParameterPair(pair, packagetype))
	end
	return out
end

function CountNonPrimitiveParams(params)
	local count = 0
	for _, pair in ipairs(params) do
		if IsNonPrimitive(pair.Gotype) then
			count = count + 1
		end
	end
	return count
end

function extractMethodName(funcLine, objectName)
	local prefix = objectName .. "_"
	local start_pos = funcLine:find(prefix, 1, true)
	if not start_pos then
		return ""
	end
	local endOfType = funcLine:sub(1, start_pos - 1):match(".*()%s") or 0
	local end_pos = funcLine:find("%(", endOfType + 1)
	if not end_pos then
		return ""
	end
	return trim(funcLine:sub(endOfType + 1, end_pos - 1))
end

function extractResultType(funcLine)
	local parenIdx = funcLine:find("%(")
	if not parenIdx then
		return ""
	end
	local beforeParen = trim(funcLine:sub(1, parenIdx - 1))
	local parts = {}
	for s in beforeParen:gmatch("%S+") do
		table.insert(parts, s)
	end
	if #parts < 2 then
		return ""
	end
	local result = {}
	for i = 1, #parts - 1 do
		table.insert(result, parts[i])
	end
	return join(result, " ")
end

function constructorGoMethodName(methodName, objectName)
	if contains(methodName, "_create") then
		local stem = trimPrefix(methodName, objectName .. "_create")
		local parts = split(stem, "_")
		for i, part in ipairs(parts) do
			parts[i] = title(part)
		end
		local newmethod = "New" .. join(parts, "")
		newmethod = replace_all(newmethod, "Farray", "FArray")
		return newmethod
	end
	if contains(methodName, "_from_json_string") then
		return "FromJSON"
	end
	return nonConstructorGoMethodName(methodName, objectName)
end

function nonConstructorGoMethodName(methodName, objectName)
	local stem = trimPrefix(methodName, objectName)
	local parts = split(stem, "_")
	for i, part in ipairs(parts) do
		parts[i] = title(part)
	end
	local out = join(parts, "")
	out = replace_all(out, "Farray", "FArray")
	if out == "ToJsonString" then
		return "ToJSON"
	end
	return out
end

function goMethodName(methodName, objectName, currentCategory)
	if currentCategory == "allocation" then
		return constructorGoMethodName(methodName, objectName)
	elseif currentCategory == "deallocation" then
		return "Close"
	else
		return nonConstructorGoMethodName(methodName, objectName)
	end
end

function writeStringConversion(Goparams, outFile)
	for _, arg in ipairs(Goparams) do
		if arg.Gotype == "string" then
			outFile:write(string.format("real%s := str.New(%s)\n", arg.Name, arg.Name))
			arg.Name = "real" .. arg.Name
		end
	end
end

function memorySize(goType, cType)
	if IsNonPrimitive(goType) or IsString(goType) then
		return string.format("unsafe.Sizeof(C.%s(nil))", cType)
	elseif goType == "bool" then
		return string.format("unsafe.Sizeof(C. %s(false))", cType)
	else
		return string.format("unsafe.Sizeof(C.%s(0))", cType)
	end
end

function emitGoMallocBlock(outFile, goVar, goLenVar, goSliceVar, cType, sizeExpr, convertExpr)
	outFile:write(
		string.format(
			[[	%s := len(%s)
	if %s == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	%s := C.malloc(C.size_t(%s) * C.size_t(%s))
	if %s == nil {
		return nil, errors.New("C.malloc failed")
	}
	slice%s := (*[1 << 30]C.%s)(%s)[:%s:%s]
	for i, v := range %s {
		slice%s[i] = %s
	}
]],
			goLenVar,
			goSliceVar,
			goLenVar,
			goVar,
			goLenVar,
			sizeExpr,
			goVar,
			goVar,
			cType,
			goVar,
			goLenVar,
			goLenVar,
			goSliceVar,
			goVar,
			convertExpr
		)
	)
end

function MakeGoArgNames(goparams)
	local names = {}
	for _, pair in ipairs(goparams) do
		if IsNonPrimitive(pair.Gotype) then
			table.insert(names, pair.Name)
		end
	end
	return join(names, ",")
end

function MakeCArgs(goparams, cparams)
	local cargs = {}
	for i, pair in ipairs(goparams) do
		local goParamHandle
		local ctype = cparams[i].Ctype
		if IsPrimitive(pair.Gotype) then
			goParamHandle = pair.Name
		else
			goParamHandle = pair.Name .. ". CAPIHandle()"
		end
		ctype = replace_all(ctype, " ", "")
		ctype = replace_all(ctype, "*", "")
		table.insert(cargs, string.format("C.%s(%s)", ctype, goParamHandle))
	end
	return join(cargs, ",")
end

function stripBlockComment(line, inBlockComment)
	local trimmed = trim(line)
	while true do
		if inBlockComment then
			local end_pos = trimmed:find("*/", 1, true)
			if not end_pos then
				return "", true
			end
			trimmed = trim(trimmed:sub(end_pos + 2))
			inBlockComment = false
		else
			local start_pos = trimmed:find("/*", 1, true)
			if not start_pos then
				break
			end
			local end_pos = trimmed:find("*/", start_pos + 2, true)
			if not end_pos then
				trimmed = trimmed:sub(1, start_pos - 1)
				inBlockComment = true
				break
			end
			trimmed = trim(trimmed:sub(1, start_pos - 1) .. trimmed:sub(end_pos + 2))
		end
	end
	return trimmed, inBlockComment
end

-- MAIN
local function main()
	if #arg < 1 then
		print("Usage: lua genFile.lua <header-file>")
		os.exit(1)
	end

	local headerPath = arg[1]
	print("processing", headerPath)

	local f = assert(io.open(headerPath, "r"))
	local manifest = assert(io.open("manifest.txt", "a"))
	manifest:write("Generating " .. headerPath .. "\n")

	local parts = split(headerPath, "falcon_core/")
	local includePath = "falcon_core/" .. parts[2]
	local base = parts[2]:match("([^/]+)$")
	local objectName = split(base, "_")[1]
	local packageName = objectName:lower()
	local dir = parts[2]:match("(.*/)") or ""
	dir = replace_all(dir, "_", "-")
	local goFileName = replace_all(objectName:sub(1, 1):lower() .. objectName:sub(2), "_", "-") .. ".go"
	local goFilePath = dir .. packageName .. "/" .. goFileName
	local outFile = assert(io.open(goFilePath, "w"))

	-- Write Go file preamble
	outFile:write(string.format(
		[[package %s
/*
#cgo pkg-config: falcon_core_c_api
#include <%s>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"unsafe"
	"errors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	%s
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)
type Handle struct { falconcorehandle.FalconCoreHandle }
var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle:  falconcorehandle. Construct(ptr)}
	}
	destroy = func(ptr unsafe. Pointer) {
		C.%s_destroy(C.%sHandle(ptr))
	}
)
func (h *Handle) IsNil() bool { return h == nil }
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
]],
		packageName,
		includePath,
		watermark,
		objectName,
		objectName
	))

	-- Main codegen loop
	local currentCategory = ""
	local funcLines = {}
	local extraImports = {}
	local reset = false
	local inBlockComment = false

	for line in f:lines() do
		repeat -- Using repeat-until as a continue block
			if reset then
				currentCategory = ""
				reset = false
			end

			line, inBlockComment = stripBlockComment(line, inBlockComment)
			if line == "" then
				break -- Continue to next iteration
			end
			line = trim(line)

			local cut, exists = cutPrefix(line, "// @category:")
			if exists then
				manifest:write("Found a category\n")
				currentCategory = trim(cut)
				break -- Continue to next iteration
			end

			if currentCategory == "" then
				break -- Continue to next iteration
			end

			table.insert(funcLines, line)
			if not hasSuffix(line, ");") then
				break -- Continue to next iteration
			end

			reset = true
			local fullSig = join(funcLines, " ")
			fullSig = replace_all(fullSig, "\n", " ")
			fullSig = replace_all(fullSig, "\t", " ")
			manifest:write("Full signal:  " .. fullSig .. "\n")
			funcLines = {}

			local resultCType = extractResultType(fullSig)
			manifest:write("result c type:  " .. resultCType .. "\n")
			local resultGoType = CtoGType(resultCType, packageName)
			manifest:write("result go type: " .. resultGoType .. "\n")
			local methodName = extractMethodName(fullSig, objectName)
			manifest:write("method name: " .. methodName .. "\n")
			local goName = goMethodName(methodName, objectName, currentCategory)
			manifest:write("go method name: " .. goName .. "\n")

			local NumParams, Cparams = countParams(fullSig)
			for _, param in ipairs(Cparams) do
				manifest:write("C param: " .. param.Ctype .. " " .. param.Name .. "\n")
			end

			local Goparams = toGoParams(Cparams, packageName)
			local NumNonPrimitiveParams = CountNonPrimitiveParams(Goparams)

			for i, param in ipairs(Goparams) do
				if IsExtraImport(param.Gotype) then
					manifest:write("Adding extra import for param: " .. param.Gotype .. "\n")
					manifest:write("Adding extra extraimport for param: " .. extractCPrefix(Cparams[i].Ctype) .. ".\n")
					table.insert(extraImports, extractCPrefix(Cparams[i].Ctype))
				end
			end

			manifest:write("Generating method: " .. goName .. "\n")
			manifest:write("  with " .. resultGoType .. " result\n")

			if IsExtraImport(resultGoType) then
				manifest:write("Adding extra import for param: " .. resultCType .. "\n")
				manifest:write("Adding extra extraimport for param: " .. extractCPrefix(resultCType) .. ".\n")
				table.insert(extraImports, extractCPrefix(resultCType))
			end

			-- Deallocation category
			if currentCategory == "deallocation" then
				outFile:write([[

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
]])
				break -- Continue to next iteration
			end

			-- Allocation category
			if currentCategory == "allocation" then
				local methodArguments = flattenGoParameters(Goparams)

				-- Special case:   HDF5_from_communications
				if NumParams == 7 and NumNonPrimitiveParams == 4 and contains(methodArguments, "measurement_title") then
					outFile:write(
						[[func NewFromCommunications(request *measurementrequest.Handle, response *measurementresponse.Handle, device_voltage_states *devicevoltagestates.Handle, session_id [16]int8, measurement_title string, unique_id int32, timestamp int32) (*Handle, error) {
	var cSessionID [16]C.int8_t
	for i := 0; i < 16; i++ {
		cSessionID[i] = C. int8_t(session_id[i])
	}
	realmeasurement_title := str.New(measurement_title)
	return cmemoryallocation.MultiRead([]cmemoryallocation. HasCAPIHandle{request, response, device_voltage_states, realmeasurement_title}, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.HDF5Data_create_from_communications(C.MeasurementRequestHandle(request. CAPIHandle()), C.MeasurementResponseHandle(response.CAPIHandle()), C.DeviceVoltageStatesHandle(device_voltage_states.CAPIHandle()), &cSessionID[0], C.StringHandle(realmeasurement_title. CAPIHandle()), C.int(unique_id), C.int(timestamp))), nil
			},
			construct,
			destroy,
		)
	})
}

]]
					)
					break -- Continue to next iteration
				end

				-- Array/shape constructors
				if
					contains(methodArguments, "*uint64")
					and (
						(
							NumParams - NumNonPrimitiveParams == 3
							and (NumNonPrimitiveParams == 1 or NumNonPrimitiveParams == 0)
						)
						or (
							NumParams == 2
							and (
								contains(methodArguments, "shape")
								or (goName == "New" and (contains(packageName, "list") or contains(packageName, "map")))
							)
						)
					)
				then
					local C0type = trim(trimSuffix(Cparams[1].Ctype, "*"))
					local Go0type, argument

					if IsString(Goparams[1].Gotype) then
						Go0type = "string"
						argument = string.format("C.%s(str.New(v).CAPIHandle())", C0type)
					elseif IsNonPrimitive(Goparams[1].Gotype) then
						Go0type = Goparams[1].Gotype
						argument = string.format("C. %s(v. CAPIHandle())", C0type)
					else
						Go0type = Goparams[1].Gotype:sub(2)
						argument = string.format("C.%s(v)", C0type)
					end

					local sizeData = memorySize(Go0type, C0type)

					if NumParams > 2 then
						local hasExtraParam = NumNonPrimitiveParams == 1
						local extraParamDecl, extraParamCall, wrapperStart, wrapperEnd = "", "", "", ""

						if hasExtraParam then
							extraParamDecl = string.format(", %s %s", Goparams[4].Name, Goparams[4].Gotype)
							extraParamCall =
								string.format(", C.%s(%s. CAPIHandle())", Cparams[4].Ctype, Goparams[4].Name)
							wrapperStart = string.format(
								"return cmemoryallocation.Read(%s, func() (*Handle, error) {",
								Goparams[4].Name
							)
							wrapperEnd = "})"
						end

						outFile:write(string.format(
							[[func %s(%s []%s, %s []uint64%s) (*Handle, error) {
]],
							goName,
							Goparams[1].Name,
							Go0type,
							Goparams[2].Name,
							extraParamDecl
						))

						emitGoMallocBlock(outFile, "cData", "nData", Goparams[1].Name, C0type, sizeData, argument)
						local sizeShape = memorySize("uint64", "size_t")
						emitGoMallocBlock(
							outFile,
							"cShape",
							"nShape",
							Goparams[2].Name,
							"size_t",
							sizeShape,
							"C.size_t(v)"
						)

						outFile:write(string.format(
							[[%s
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				res := unsafe.Pointer(C.%s((*C.%s)(cData), (*C.size_t)(cShape), C.size_t(nShape)%s))
				C.free(cData)
				C.free(cShape)
				return res, nil
			},
			construct,
			destroy,
		)
	%s
}
]],
							wrapperStart,
							methodName,
							C0type,
							extraParamCall,
							wrapperEnd
						))
					else
						outFile:write(string.format(
							[[func %s(%s []%s) (*Handle, error) {
]],
							goName,
							Goparams[1].Name,
							Go0type
						))
						emitGoMallocBlock(outFile, "cData", "nData", Goparams[1].Name, C0type, sizeData, argument)
						outFile:write(string.format(
							[[return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.%s((*C. %s)(cData), C.size_t(nData)))
			C.free(cData)
			return res, nil
		},
		construct,
		destroy,
	)
}
]],
							methodName,
							C0type
						))
					end
					break -- Continue to next iteration
				end

				-- Listlike_create special case
				if NumNonPrimitiveParams == 1 and goName == "New" and contains(methodArguments, "list") then
					local goItemType
					local itemPackageName = ""
					local starIdx = methodArguments:find("*", 1, true)
					local dotIdx = starIdx and methodArguments:find("%.", starIdx)

					if starIdx and dotIdx then
						-- Extract type between * and .
						local typeName = methodArguments:sub(starIdx + 1, dotIdx - 1)
						itemPackageName = trimPrefix(typeName, "list")
						goItemType = CtoGType(itemPackageName, itemPackageName)
						if goItemType == "*Handle" then
							goItemType = "*" .. itemPackageName .. ".Handle"
						end
					else
						-- No dot found or no star - likely a self-referential *Handle
						-- For ListAcquisitionContext, the item type is just *Handle (same package)
						goItemType = "*Handle"
						itemPackageName = packageName
					end

					outFile:write(string.format(
						[[func New(items []%s) (*Handle, error) {
	list, err := list%s. New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of %s failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	},)
}
]],
						goItemType,
						itemPackageName,
						itemPackageName
					))
					outFile:write(string.format("func NewFromList(%s) (*Handle, error) {\n", methodArguments))
				else
					outFile:write(string.format("func %s(%s) (*Handle, error) {\n", goName, methodArguments))
				end

				writeStringConversion(Goparams, outFile)
				local carguments = MakeCArgs(Goparams, Cparams)
				local gonames = MakeGoArgNames(Goparams)

				if NumNonPrimitiveParams == 1 then
					outFile:write(
						string.format("  return cmemoryallocation.Read(%s, func() (*Handle, error) {\n", gonames)
					)
				elseif NumNonPrimitiveParams > 1 then
					outFile:write(
						string.format(
							"  return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{%s}, func() (*Handle, error) {\n",
							gonames
						)
					)
				end

				outFile:write(string.format(
					[[

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.%s(%s)), nil
			},
			construct,
			destroy,
		)
	}]],
					methodName,
					carguments
				))

				if NumNonPrimitiveParams > 0 then
					outFile:write(",  )\n}\n")
				else
					outFile:write("\n")
				end
				break -- Continue to next iteration
			end

			-- Read and other categories
			local methodArguments = flattenGoParameters({ table.unpack(Goparams, 2) })
			Goparams[1] = { Gotype = "*Handle", Name = "h" }

			if currentCategory == "read" then
				-- reshape special case
				if contains(methodArguments, "shape") and contains(methodArguments, "*uint64") then
					outFile:write(
						string.format(
							[[func (h *Handle) %s(%s []int32) (*Handle, error) {
	cshape := make([]C.size_t, len(%s))
	for i, v := range %s {
		cshape[i] = C. size_t(v)
	}
	return cmemoryallocation.Read(h, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.%s(C.%s(h.CAPIHandle()), &cshape[0], C. size_t(len(%s)))), nil
			},
			construct,
			destroy,
		)
	})
}
]],
							goName,
							Goparams[2].Name,
							Goparams[2].Name,
							Goparams[2].Name,
							methodName,
							Cparams[1].Ctype,
							Goparams[2].Name
						)
					)
					break -- Continue to next iteration
				end

				if not contains(methodArguments, "out_buffer") then
					outFile:write(
						string.format("func (h *Handle) %s(%s) (%s, error) { \n", goName, methodArguments, resultGoType)
					)
					writeStringConversion(Goparams, outFile)
					local carguments = MakeCArgs(Goparams, Cparams)
					local gonames = MakeGoArgNames(Goparams)

					if NumNonPrimitiveParams == 1 then
						outFile:write(
							string.format(
								"  return cmemoryallocation. Read(%s, func() (%s, error) { \n",
								gonames,
								resultGoType
							)
						)
					elseif NumNonPrimitiveParams > 1 then
						outFile:write(
							string.format(
								"  return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{%s}, func() (%s, error) { \n",
								gonames,
								resultGoType
							)
						)
					end

					local cfunction = string.format("C.%s(%s)", methodName, carguments)

					if IsPrimitive(resultGoType) then
						outFile:write(string.format("return %s(%s), nil", resultGoType, cfunction))
					elseif IsString(resultGoType) then
						outFile:write(string.format(
							[[

		strObj, err := str.FromCAPI(unsafe.Pointer(%s))
		if err != nil {
			return "", errors.New("%s:" + err.Error())
		}
		return strObj.ToGoString()
]],
							cfunction,
							goName
						))
					elseif resultGoType == "*Handle" then
						outFile:write(string.format(
							[[

		return FromCAPI(unsafe.Pointer(%s))
]],
							cfunction
						))
					else
						local resultPackage = extractGoPrefix(resultGoType)
						outFile:write(string.format(
							[[

		return %s. FromCAPI(unsafe.Pointer(%s))
]],
							resultPackage,
							cfunction
						))
					end

					outFile:write("  })\n}\n")
					break -- Continue to next iteration
				else
					-- out_buffer case
					local bufferParam
					for _, param in ipairs(Cparams) do
						if param.Name == "out_buffer" then
							bufferParam = param
							break
						end
					end

					local bufferCType = bufferParam.Ctype:sub(1, -2)
					local bufferGoType = CtoGType(bufferCType, packageName)
					local reconstruction

					if IsNonPrimitive(bufferGoType) and not IsString(bufferGoType) then
						local bufferpackage = extractGoPrefix(bufferGoType)
						if bufferpackage ~= "Handle" then
							bufferpackage = bufferpackage .. "."
						else
							bufferpackage = ""
						end
						reconstruction = string.format(
							[[realout[i], err = %sFromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("%s:  conversion from CAPI failed"), err)
		}
]],
							bufferpackage,
							goName
						)
					elseif IsString(bufferGoType) then
						reconstruction = [[realstr, err := str.FromCAPI(unsafe. Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("string:  conversion from capi failed"), err)
		}
		realout[i], err = realstr.ToGoString()
		if err != nil {
			return nil, errors.Join(errors. New("string: conversion to string failed"), err)
		}
]]
					else
						reconstruction = string.format("realout[i] = %s(out[i])\n", bufferGoType)
					end

					local size = objectName .. "_size"
					if contains(goName, "Gradient") or contains(goName, "Shape") then
						size = objectName .. "_dimension"
					end

					outFile:write(
						string.format(
							[[func (h *Handle) %s() ([]%s, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.%s(C.%sHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("%s: size errored"), err)
	}
	out := make([]C.%s, dim)
	_, err = cmemoryallocation. Read(h, func() (bool, error) {
		C.%s(C.%sHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]%s, dim)
	for i := range out {
		%s
	}
	return realout, nil
}
]],
							goName,
							bufferGoType,
							size,
							objectName,
							goName,
							bufferCType,
							methodName,
							objectName,
							bufferGoType,
							reconstruction
						)
					)
					break -- Continue to next iteration
				end
			end

			-- Write category
			outFile:write(string.format("func (h *Handle) %s(%s) error { \n", goName, methodArguments))
			writeStringConversion(Goparams, outFile)
			local carguments = MakeCArgs(Goparams, Cparams)
			local gonames_list = {}
			for i = 2, #Goparams do
				if IsNonPrimitive(Goparams[i].Gotype) then
					table.insert(gonames_list, Goparams[i].Name)
				end
			end
			local gonames = join(gonames_list, ",")

			if NumNonPrimitiveParams == 1 then
				outFile:write(string.format("  return cmemoryallocation. Write(%s, func() error {\n", Goparams[1].Name))
			elseif NumNonPrimitiveParams > 1 then
				outFile:write(
					string.format(
						"  return cmemoryallocation.ReadWrite(%s, []cmemoryallocation.HasCAPIHandle{%s}, func() error {\n",
						Goparams[1].Name,
						gonames
					)
				)
			end

			outFile:write(string.format(
				[[C.%s(%s)
 return nil 
}) 
}
]],
				methodName,
				carguments
			))
		until true -- End of repeat-until block (acts as a continue mechanism)
	end

	f:close()
	outFile:close()

	manifest:write("Extra imports before uniqueStrings:   " .. table.concat(extraImports, ", ") .. "\n")
	extraImports = uniqueStrings(extraImports)
	manifest:write("Extra imports:   " .. table.concat(extraImports, ", ") .. "\n")

	-- Finally reinject imports at the watermark
	local goImportPaths = {}
	for _, extraImport in ipairs(extraImports) do
		local importPath = findGoImport(headerPath, extraImport)
		if not importPath then
			panic("Could not find import for " .. extraImport)
		end
		table.insert(goImportPaths, importPath)
	end

	insertImports(goFilePath, goImportPaths)
	manifest:write("Imports inserted successfully.\n")
	manifest:close()
end

main()

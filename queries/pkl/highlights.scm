; Copyright © 2024-2025 Apple Inc. and the Pkl project authors. All rights reserved.
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;   https://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

; List of captures supported by nvim-treesitter:
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights

; Types

(clazz (identifier) @type)
(typeAlias (identifier) @type)
((identifier) @type
 (#match? @type "^[A-Z]"))

(typeArgumentList
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

; Method calls

(methodCallExpr
  (identifier) @function.call)

; Method definitions

(classMethod (methodHeader (identifier)) @function.method)
(objectMethod (methodHeader (identifier)) @function.method)

; Identifiers

(classProperty (identifier) @property)
(objectProperty (identifier) @property)

(parameterList (typedIdentifier (identifier) @variable.parameter))
(objectBodyParameters (typedIdentifier (identifier) @variable.parameter))

(annotation (qualifiedIdentifier) @attribute)
(forGenerator (typedIdentifier (identifier) @variable))
(letExpr (typedIdentifier (identifier) @variable))
(variableExpr (identifier) @variable)
(importClause (identifier) @variable)
(variableObjectLiteral (identifier) @variable)
(propertyCallExpr (identifier) @variable)

; (identifier) @variable

; Literals

(stringConstant) @string
(slStringLiteral) @string
(mlStringLiteral) @string

(escapeSequence) @string.escape

(intLiteral) @number
(floatLiteral) @number

(interpolationExpr
  "\\(" @punctuation.special
  ")" @punctuation.special) @none

(interpolationExpr
 "\\#(" @punctuation.special
 ")" @punctuation.special) @none

(interpolationExpr
  "\\##(" @punctuation.special
  ")" @punctuation.special) @none

(lineComment) @comment
(blockComment) @comment
(docComment) @comment.documentation

; Operators

"??" @operator
"@"  @operator
"="  @operator
"<"  @operator
">"  @operator
"!"  @operator
"==" @operator
"!=" @operator
"<=" @operator
">=" @operator
"&&" @operator
"||" @operator
"+"  @operator
"-"  @operator
"**" @operator
"*"  @operator
"/"  @operator
"~/" @operator
"%"  @operator
"|>" @operator

"?"  @operator.type
"|"  @operator.type
"->" @operator.type

"..." @punctuation
"...?" @punctuation
"," @punctuation.delimiter
":" @punctuation.delimiter
"." @punctuation.delimiter
"?." @punctuation.delimiter

"(" @punctuation.bracket
")" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

; Keywords

"abstract" @keyword
"amends" @keyword
"as" @keyword
"class" @keyword
"else" @keyword.conditional ; TODO: fix 'else' not highlighting after 'when'
"extends" @keyword
"external" @keyword
(falseLiteral) @boolean
"for" @keyword.repeat
"function" @keyword.function
"hidden" @keyword
"if" @keyword.conditional
"import" @keyword.import
"import*" @keyword.import
"in" @keyword
"is" @keyword
"let" @keyword
"local" @keyword
"module" @keyword
"new" @keyword
(nullLiteral) @constant.builtin
"open" @keyword
"out" @keyword
(outerExpr) @variable.builtin
"read" @function.method.builtin
"read?" @function.method.builtin
"read*" @function.method.builtin
"super" @variable.builtin
(thisExpr) @variable.builtin
"throw" @function.method.builtin
"trace" @function.method.builtin
(trueLiteral) @boolean
"typealias" @keyword
(nothingType) @type.builtin
(unknownType) @type.builtin
(moduleType) @type.builtin
"when" @keyword.conditional

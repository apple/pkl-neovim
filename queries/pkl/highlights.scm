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
(declaredType (qualifiedIdentifier (identifier) @type))

(typeArgumentList
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

; Access
(unqualifiedAccessExpr
  (identifier) @property)

(qualifiedAccessExpr
  (identifier) @variable.member)

(qualifiedAccessExpr
  (identifier) @function.call (argumentList))

(unqualifiedAccessExpr
  (identifier) @function.call (argumentList))

; Method definitions

(classMethod (methodHeader (identifier)) @function.method)
(objectMethod (methodHeader (identifier)) @function.method)

; Identifiers

(classProperty (identifier) @variable.member)
(objectProperty (identifier) @variable.member)

(annotation "@" @attribute (qualifiedIdentifier (identifier) @attribute))

(typedIdentifier (identifier) @variable.parameter)
(blankIdentifier) @variable.parameter.builtin
(importClause (identifier) @variable)

; Literals

(stringConstant) @string
(slStringLiteralExpr) @string
(mlStringLiteralExpr) @string

(escapeSequence) @string.escape

(intLiteralExpr) @number
(floatLiteralExpr) @number.float

(stringInterpolation
  "\\(" @punctuation.special
  ")" @punctuation.special) @none

(stringInterpolation
 "\\#(" @punctuation.special
 ")" @punctuation.special) @none

(stringInterpolation
  "\\##(" @punctuation.special
  ")" @punctuation.special) @none

(lineComment) @comment
(blockComment) @comment
(docComment) @comment.documentation

; Operators

"??" @operator
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
"else" @keyword.conditional
"extends" @keyword
"external" @keyword
(falseLiteralExpr) @boolean
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
(nullLiteralExpr) @constant.builtin
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
(trueLiteralExpr) @boolean
"typealias" @keyword
(nothingType) @type.builtin
(unknownType) @type.builtin
(moduleType) @type.builtin
"when" @keyword.conditional

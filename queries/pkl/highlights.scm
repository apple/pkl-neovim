; Copyright © 2024 Apple Inc. and the Pkl project authors. All rights reserved.
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     https://www.apache.org/licenses/LICENSE-2.0
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
 (match? @type "^[A-Z]"))

(typeArgumentList
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(typeParameter (identifier) @type)
(typeAnnotation (type (qualifiedIdentifier) @type))
(newExpr (type (qualifiedIdentifier) @type))

; Method calls

(methodCallExpr
  (identifier) @method)

; Method definitions

(classMethod (methodHeader (identifier)) @method)
(objectMethod (methodHeader (identifier)) @method)

; Identifiers

(classProperty (identifier) @property)
(objectProperty (identifier) @property)

(parameterList (typedIdentifier (identifier) @parameter))
(objectBodyParameters (typedIdentifier (identifier) @parameter))

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
(docComment) @comment

; Operators

"??" @operator
"@"  @attribute
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
; "[" @punctuation.bracket TODO: FIGURE OUT HOW TO REFER TO CUSTOM TOKENS
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

; Keywords

"abstract" @keyword
"amends" @keyword
"as" @keyword
"class" @keyword
"else" @conditional
"extends" @keyword
"external" @keyword
(falseLiteral) @boolean
"for" @repeat
"function" @keyword
"hidden" @keyword
"if" @conditional
(importExpr "import" @include)
(importGlobExpr "import*" @include)
(importClause "import" @include)
(importGlobClause "import*" @include)
(importClause "as" @include)
"in" @repeat
"is" @keyword.operator
"let" @keyword
"local" @keyword
(moduleExpr "module" @type.builtin)
"module" @keyword
"new" @keyword
"nothing" @type.builtin
(nullLiteral) @constant.builtin
"open" @keyword
"out" @keyword
(outerExpr) @variable.builtin
"read" @function.builtin
"read?" @function.builtin
"read*" @function.builtin
"super" @variable.builtin
(thisExpr) @variable.builtin
"throw" @function.builtin
"trace" @function.builtin
(trueLiteral) @boolean
"typealias" @keyword
"unknown" @type.builtin
"when" @conditional

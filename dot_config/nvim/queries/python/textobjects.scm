;; inherits: python
;; extends

; import foo, bar
(import_statement
  "import" (_) @import.outer)

; from pkg import foo, bar
(import_from_statement
  "from" (_) @import.outer
  "import" (_) @import.inner)   ; optional: inner = the part after `import`


(import_statement
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(import_statement
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(import_from_statement
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(import_from_statement
  "import"
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

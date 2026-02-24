;; inherits: python
;; extends

; import foo, bar
(import_statement
  "import" (_) @import.outer)

; from pkg import foo, bar
(import_from_statement
  "from" (_) @import.outer
  "import" (_) @import.inner)   ; optional: inner = the part after `import`


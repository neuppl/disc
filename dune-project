(lang dune 3.9)

(name disc)

(generate_opam_files true)

(using menhir 2.1)

(source
 (github username/reponame))

(authors "Steven Holtzen")

(maintainers "Steven Holtzen")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name disc)
 (synopsis "Disc: A Tiny Discrete Probabilistic Programming Language")
 (description "")
 (depends ocaml dune core menhir ounit qcheck bignum)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

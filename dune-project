(lang dune 2.5)
(version 0.0.1)
(generate_opam_files true)
(package
 (name tv)
 (maintainers a-manning)
 (depends
   (core (>= v0.13.0))
   (ctypes (>= 0.17.1))
   (ctypes-foreign (>= 0.4.0)))
 (synopsis "Control my tv"))

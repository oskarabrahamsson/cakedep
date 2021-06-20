(* -------------------------------------------------------------------------
 * cakedep tests
 * ------------------------------------------------------------------------- *)

fun print_err msg = TextIO.output (TextIO.stdErr, msg);

fun die () =
  OS.Process.exit OS.Process.failure;

fun run_test {
    test_name = name,
    test_fn = test_fn,
    should_fail = bad } =
  let
    val _ = print ("[" ^ name ^ "] (")
    val _ = print (if bad then "BAD" else "GOOD")
    val _ = print ") ... "
    val results = test_fn ()
    val success = List.all OS.Process.isSuccess results
  in
    if bad andalso success then
      (print "FAIL\n"; die ())
    else if bad orelse success then
      print "OK!\n"
    else
      (print "FAIL\n"; die ())
  end;

val cakedep = "../cakedep -- ";

fun run_cakedep dir args =
  OS.Process.system ("cd " ^ dir ^ " && ../" ^ cakedep ^
                     args ^ " 2> /dev/null");

(* -------------------------------------------------------------------------
 * Cyclical dependencies, etc
 * ------------------------------------------------------------------------- *)

val test_cycles = {
  test_name = "cyclical dependencies",
  should_fail = true,
  test_fn = fn () =>
    let
      val r1 = run_cakedep "cycles" "a.cml"
      val r2 = run_cakedep "cycles" "b.cml"
      val r3 = run_cakedep "cycles" "c.cml"
    in
      [r1, r2, r3]
    end
  };

val test_selfdep = {
  test_name = "self-dependency",
  should_fail = true,
  test_fn = fn () => [run_cakedep "selfdep" "a.cml"]
  };

(* -------------------------------------------------------------------------
 * Run tests
 * ------------------------------------------------------------------------- *)

val all_tests = [
    test_cycles,
    test_selfdep
  ];

fun main () =
  (print "Running tests ...\n";
   List.app run_test all_tests;
   print "Tests succeeded.\n");

